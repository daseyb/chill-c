﻿Shader "Grove/UnlitCutout"
{
	Properties
	{
		_Color ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Emission ("Emission", Range (0,4)) = 1.0
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
		
		_Cutoff ("Alpha cutoff", Range (0,1)) = 0.1
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;	
			};
			
			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _MainTex_ST;
			float _Cutoff;
			float _Emission;
			float4 _Color;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				fixed4 col = tex2D(_MainTex, i.uv) * float4(1.0, 1.0, 1.0, tex2D(_MaskTex, i.uv).a < _Cutoff ? 1.0 : 0.0);
				col *= _Color * float4(_Emission, _Emission, _Emission, 1.0);
				return col;
			}
			ENDCG
		}
	}
}
