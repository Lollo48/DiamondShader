Shader "Unlit/Diamond3"
{
    Properties
    {
        _RimColor("Rim Color", Color) = (1, 1, 1, 1)
        _RimIntensity("Rim Intensity", Range(0, 1)) = 0
        _RimPower("Rim Power", Range(0, 5)) = 1
        _Transparency("Transparency", Range(0, 1)) = 0

    }
    SubShader
    {
        Tags {"Queue"= "Transparent" "RenderType"="Transparent" }
        LOD 100
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;

                float3 worldNormal : TEXCOORD1;
                float3 viewDirection : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _RimColor;
            float _RimIntensity;
            float _RimPower;
            float _Transparency;

            float4 rimLight(float4 color, float3 normal, float3 viewDirection)
            {
                float NdotV = 1 - dot(normal, viewDirection);
                NdotV = pow(NdotV, _RimPower);
                NdotV *= _RimIntensity;
                float4 finalColor = lerp(color, _RimColor, NdotV);
                return finalColor;
            }


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.viewDirection = WorldSpaceViewDir(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                i.worldNormal = normalize(i.worldNormal);
                i.viewDirection = normalize(i.viewDirection);

                col = rimLight(col, i.worldNormal, i.viewDirection);

                col.a = _Transparency;

                return col;
            }
            ENDCG
        }
    }
}
