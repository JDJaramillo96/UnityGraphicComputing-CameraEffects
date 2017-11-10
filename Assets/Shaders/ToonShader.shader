Shader "Custom/ToonShader" {
	
	Properties {
		
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Ramp ("Ramp (Grayscale)", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
	}

	SubShader {
		
		Tags { "RenderType" = "Opaque" }
		
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf ToonLighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Ramp;
		float4 _Color;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};

		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput output) {
			//Textures info
			float4 texInfo = tex2D (_MainTex, IN.uv_MainTex);
			//Dot product
			half dotProduct = dot(IN.worldNormal, IN.viewDir);
			//Output setup
			output.Albedo = texInfo.rgb * _Color.rgb;
		}

		float4 LightingToonLighting (SurfaceOutput output, float3 lightDirection, float lightAtten) {
			//LightAtten correction
			float newlightAtten;
			newlightAtten = lightAtten + 1;
			newlightAtten *= 0.5;
			//Light
			float light = abs(dot(output.Normal, lightDirection));
			//Tex info
			float rampInfo = tex2D(_Ramp, float2(clamp(light * newlightAtten, 0, 1), 0.5));
			//Final color
			float4 color;
			color.rgb = rampInfo * _LightColor0.rgb * output.Albedo.rgb;
			return color;
		}

		ENDCG
	}

	FallBack "Diffuse"
}
