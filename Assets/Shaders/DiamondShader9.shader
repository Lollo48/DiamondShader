Shader "Unlit/Diamond9"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)


		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimPower("Rim Power", Range(0,10)) = 0
		_RimIntensity("Rim Intensity", Range(0, 10)) = 0

		_Hollowness("Hollowness", Range(0,1)) = 0
		_Distortion("Distortion", Range(-2,2)) = 0
	}
	SubShader
	{

		Tags { "Queue" = "Transparent" }

		GrabPass 
		{
			"_GrabTexture"
		}


		Pass {

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _GrabTexture;
			float4 _Color;

			half _Glossiness;
			half _Metallic;

			float4 _RimColor;
			float _RimPower;
			float _RimIntensity;

			float _Distortion;
			float _Hollowness;

			struct appdata 
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};


			struct v2f {
				float4 pos : POSITION;
				float4 grabPos : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
				float4 worldPos : TEXCOORD3;
				float3 normal : NORMAL;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);

				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.viewDir = normalize(UnityWorldSpaceViewDir(o.worldPos));

				 return o;
			}

			float4 rimLight(float4 color, float3 normal, float3 viewDirection)
			{

				float NdotV = 1 - dot(normal, viewDirection);
				NdotV = pow(NdotV, _RimPower);
				NdotV *= _RimIntensity;
				float4 col = lerp(color, _RimColor, NdotV);
				return col;
			}

			 fixed4 frag(v2f i) : COLOR
			 {
				float dotProduct = dot(i.viewDir, i.normal);
				 i.grabPos.xy = i.grabPos.xy + _Distortion * (_Hollowness - dotProduct) * i.normal.zyx;
				 
				 float4 col = tex2Dproj(_GrabTexture,i.grabPos);

				 col *= _Color;
				 col = rimLight(col, i.normal, i.viewDir);

				 return col;
			 }

			 ENDCG
		}
	}
}