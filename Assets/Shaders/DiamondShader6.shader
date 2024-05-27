Shader "Unlit/Diamond6"
{
	Properties
	{
		_Hollowness("Hollowness", Range(0,1)) = 0
		_Distortion("Distortion", Range(-5,5)) = 0
	}
		SubShader
	{

		Tags { "Queue" = "Transparent" }

		GrabPass
		{
			"_GrabTexture"
		}


		Pass {
			Name "GrabDistort"
			Cull Back
			ZWrite Off
			Blend Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _GrabTexture;
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


			 fixed4 frag(v2f i) : COLOR
			 {
				 float dotProduct = dot(i.viewDir, i.normal);
				 i.grabPos.xy = i.grabPos.xy + _Distortion * (_Hollowness - dotProduct) * i.normal.zyx;
				 float4 col = tex2Dproj(_GrabTexture,i.grabPos);

				 return col;
			 }
			 ENDCG
		 }
	}
}