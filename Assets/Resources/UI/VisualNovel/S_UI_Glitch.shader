Shader "UI/UIGlitch"
{
    Properties
    {
        Vector1_3713D1A9("noise_width", Float) = 0.7
        Vector1_B683118F("noise_height", Float) = 0.3
        Vector4_62004688("Min X Min Y Max X Max Y", Vector) = (0, 0, 1, 1)
        Vector1_27B2E7CC("GridSize", Float) = 15
        Vector1_6A243453("GridRatio", Float) = 2
        [NoScaleOffset]Texture2D_E4D35851("Mask", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            Name "Pass"
            Tags 
            { 
                // LightMode: <None>
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Back
            ZTest LEqual
            ZWrite Off
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma shader_feature _ _SAMPLE_GI
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #pragma multi_compile_instancing
            #define SHADERPASS_UNLIT
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float Vector1_3713D1A9;
            float Vector1_B683118F;
            float4 Vector4_62004688;
            float Vector1_27B2E7CC;
            float Vector1_6A243453;
            CBUFFER_END
            Gradient Gradient_E9031476_Definition()
            {
                Gradient g;
                g.type = 0;
                g.colorsLength = 5;
                g.alphasLength = 2;
                g.colors[0] = float4(0.4901961, 0.9529412, 0.8601972, 0.2558785);
                g.colors[1] = float4(0.9368421, 0.9921569, 0.5843138, 0.3323568);
                g.colors[2] = float4(0.850422, 0.6580189, 0.8773585, 0.4176547);
                g.colors[3] = float4(0.495283, 0.7701947, 1, 0.4823529);
                g.colors[4] = float4(0.9150943, 0.5740922, 0.7770703, 0.5676509);
                g.colors[5] = float4(0, 0, 0, 0);
                g.colors[6] = float4(0, 0, 0, 0);
                g.colors[7] = float4(0, 0, 0, 0);
                g.alphas[0] = float2(1, 0);
                g.alphas[1] = float2(1, 1);
                g.alphas[2] = float2(0, 0);
                g.alphas[3] = float2(0, 0);
                g.alphas[4] = float2(0, 0);
                g.alphas[5] = float2(0, 0);
                g.alphas[6] = float2(0, 0);
                g.alphas[7] = float2(0, 0);
                return g;
            }
            #define Gradient_E9031476 Gradient_E9031476_Definition()
            TEXTURE2D(Texture2D_E4D35851); SAMPLER(samplerTexture2D_E4D35851); float4 Texture2D_E4D35851_TexelSize;
        
            // Graph Functions
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Minimum_float(float A, float B, out float Out)
            {
                Out = min(A, B);
            };
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Step_float(float Edge, float In, out float Out)
            {
                Out = step(Edge, In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A - B;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Fraction_float4(float4 In, out float4 Out)
            {
                Out = frac(In);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
            {
                Out = floor(In / (1 / Steps)) * (1 / Steps);
            }
            
            
            inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
            {
                return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
            }
            
            inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
            {
                return (1.0-t)*a + (t*b);
            }
            
            
            inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
            {
                float2 i = floor(uv);
                float2 f = frac(uv);
                f = f * f * (3.0 - 2.0 * f);
            
                uv = abs(frac(uv) - 0.5);
                float2 c0 = i + float2(0.0, 0.0);
                float2 c1 = i + float2(1.0, 0.0);
                float2 c2 = i + float2(0.0, 1.0);
                float2 c3 = i + float2(1.0, 1.0);
                float r0 = Unity_SimpleNoise_RandomValue_float(c0);
                float r1 = Unity_SimpleNoise_RandomValue_float(c1);
                float r2 = Unity_SimpleNoise_RandomValue_float(c2);
                float r3 = Unity_SimpleNoise_RandomValue_float(c3);
            
                float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
                float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
                float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
                return t;
            }
            void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
            {
                float t = 0.0;
            
                float freq = pow(2.0, float(0));
                float amp = pow(0.5, float(3-0));
                t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
            
                freq = pow(2.0, float(1));
                amp = pow(0.5, float(3-1));
                t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
            
                freq = pow(2.0, float(2));
                amp = pow(0.5, float(3-2));
                t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
            
                Out = t;
            }
            
            void Unity_Fraction_float(float In, out float Out)
            {
                Out = frac(In);
            }
            
            void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
            {
                float Distance = distance(MaskColor, In);
                Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
            }
            
            void Unity_Rectangle_float(float2 UV, float Width, float Height, out float Out)
            {
                float2 d = abs(UV * 2 - 1) - float2(Width, Height);
                d = 1 - d / fwidth(d);
                Out = saturate(min(d.x, d.y));
            }
            
            void Unity_SampleGradient_float(Gradient Gradient, float Time, out float4 Out)
            {
                float3 color = Gradient.colors[0].rgb;
                [unroll]
                for (int c = 1; c < 8; c++)
                {
                    float colorPos = saturate((Time - Gradient.colors[c-1].w) / (Gradient.colors[c].w - Gradient.colors[c-1].w)) * step(c, Gradient.colorsLength-1);
                    color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
                }
            #ifndef UNITY_COLORSPACE_GAMMA
                color = SRGBToLinear(color);
            #endif
                float alpha = Gradient.alphas[0].x;
                [unroll]
                for (int a = 1; a < 8; a++)
                {
                    float alphaPos = saturate((Time - Gradient.alphas[a-1].y) / (Gradient.alphas[a].y - Gradient.alphas[a-1].y)) * step(a, Gradient.alphasLength-1);
                    alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
                }
                Out = float4(color, alpha);
            }
        
            // Graph Vertex
            // GraphVertex: <None>
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float4 uv0;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Color;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _UV_C370CDB7_Out_0 = IN.uv0;
                float _Split_1F68BB03_R_1 = _UV_C370CDB7_Out_0[0];
                float _Split_1F68BB03_G_2 = _UV_C370CDB7_Out_0[1];
                float _Split_1F68BB03_B_3 = _UV_C370CDB7_Out_0[2];
                float _Split_1F68BB03_A_4 = _UV_C370CDB7_Out_0[3];
                float4 _Property_B84A3F19_Out_0 = Vector4_62004688;
                float _Split_855822D1_R_1 = _Property_B84A3F19_Out_0[0];
                float _Split_855822D1_G_2 = _Property_B84A3F19_Out_0[1];
                float _Split_855822D1_B_3 = _Property_B84A3F19_Out_0[2];
                float _Split_855822D1_A_4 = _Property_B84A3F19_Out_0[3];
                float _Maximum_D6EF91E4_Out_2;
                Unity_Maximum_float(_Split_1F68BB03_R_1, _Split_855822D1_R_1, _Maximum_D6EF91E4_Out_2);
                float _Minimum_825E3952_Out_2;
                Unity_Minimum_float(_Split_1F68BB03_R_1, _Split_855822D1_B_3, _Minimum_825E3952_Out_2);
                float _Subtract_C4C37B82_Out_2;
                Unity_Subtract_float(_Maximum_D6EF91E4_Out_2, _Minimum_825E3952_Out_2, _Subtract_C4C37B82_Out_2);
                float _Step_A68487AD_Out_2;
                Unity_Step_float(_Subtract_C4C37B82_Out_2, 0, _Step_A68487AD_Out_2);
                float _Maximum_468BF54A_Out_2;
                Unity_Maximum_float(_Split_1F68BB03_G_2, _Split_855822D1_G_2, _Maximum_468BF54A_Out_2);
                float _Minimum_40DD615F_Out_2;
                Unity_Minimum_float(_Split_1F68BB03_G_2, _Split_855822D1_A_4, _Minimum_40DD615F_Out_2);
                float _Subtract_A65B73C4_Out_2;
                Unity_Subtract_float(_Maximum_468BF54A_Out_2, _Minimum_40DD615F_Out_2, _Subtract_A65B73C4_Out_2);
                float _Step_5BC0B879_Out_2;
                Unity_Step_float(_Subtract_A65B73C4_Out_2, 0, _Step_5BC0B879_Out_2);
                float _Multiply_39963897_Out_2;
                Unity_Multiply_float(_Step_A68487AD_Out_2, _Step_5BC0B879_Out_2, _Multiply_39963897_Out_2);
                float4 _Subtract_E19921F4_Out_2;
                Unity_Subtract_float4(_UV_C370CDB7_Out_0, float4(0, 0, 0, 0), _Subtract_E19921F4_Out_2);
                float4 _Multiply_AB278265_Out_2;
                Unity_Multiply_float(_Subtract_E19921F4_Out_2, float4(5, 1, 1, 1), _Multiply_AB278265_Out_2);
                float4 _Fraction_BF583C1C_Out_1;
                Unity_Fraction_float4(_Multiply_AB278265_Out_2, _Fraction_BF583C1C_Out_1);
                float4 _Multiply_6C930300_Out_2;
                Unity_Multiply_float(_Fraction_BF583C1C_Out_1, float4(0.2, 1, 1, 1), _Multiply_6C930300_Out_2);
                float4 _Add_CF76F001_Out_2;
                Unity_Add_float4(_Multiply_6C930300_Out_2, float4(0, 0, 0, 0), _Add_CF76F001_Out_2);
                float4 _Multiply_2A269DB1_Out_2;
                Unity_Multiply_float((_Multiply_39963897_Out_2.xxxx), _Add_CF76F001_Out_2, _Multiply_2A269DB1_Out_2);
                float4 _Add_7D6AE11_Out_2;
                Unity_Add_float4(_Multiply_2A269DB1_Out_2, float4(0, 0, 0, 0), _Add_7D6AE11_Out_2);
                float _Property_723DCD97_Out_0 = Vector1_27B2E7CC;
                float _Property_A0F8AF92_Out_0 = Vector1_6A243453;
                float _Multiply_C92B5029_Out_2;
                Unity_Multiply_float(_Property_723DCD97_Out_0, _Property_A0F8AF92_Out_0, _Multiply_C92B5029_Out_2);
                float4 _Vector4_13A9A5E5_Out_0 = float4(_Property_723DCD97_Out_0, _Multiply_C92B5029_Out_2, _Property_723DCD97_Out_0, _Property_723DCD97_Out_0);
                float4 _Multiply_34667561_Out_2;
                Unity_Multiply_float(_Add_7D6AE11_Out_2, _Vector4_13A9A5E5_Out_0, _Multiply_34667561_Out_2);
                float4 _Fraction_546B575B_Out_1;
                Unity_Fraction_float4(_Multiply_34667561_Out_2, _Fraction_546B575B_Out_1);
                float _Property_2A7DC9C2_Out_0 = Vector1_3713D1A9;
                float _Property_6CD60F12_Out_0 = Vector1_B683118F;
                float4 _UV_91F5080D_Out_0 = IN.uv0;
                float _Property_E5B773C2_Out_0 = Vector1_27B2E7CC;
                float4 _Vector4_E968D17C_Out_0 = float4(_Property_E5B773C2_Out_0, _Property_E5B773C2_Out_0, _Property_E5B773C2_Out_0, _Property_E5B773C2_Out_0);
                float4 _Posterize_689219AB_Out_2;
                Unity_Posterize_float4(_UV_91F5080D_Out_0, _Vector4_E968D17C_Out_0, _Posterize_689219AB_Out_2);
                float _SimpleNoise_8270394E_Out_2;
                Unity_SimpleNoise_float((_Posterize_689219AB_Out_2.xy), 35.1, _SimpleNoise_8270394E_Out_2);
                float _Multiply_7A4588D0_Out_2;
                Unity_Multiply_float(_SimpleNoise_8270394E_Out_2, IN.TimeParameters.x, _Multiply_7A4588D0_Out_2);
                float _Fraction_2A157435_Out_1;
                Unity_Fraction_float(_Multiply_7A4588D0_Out_2, _Fraction_2A157435_Out_1);
                float _ColorMask_272FC211_Out_3;
                Unity_ColorMask_float((_Fraction_2A157435_Out_1.xxx), IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0)), 0.2, _ColorMask_272FC211_Out_3, 0.57);
                float _Multiply_1D98ADD7_Out_2;
                Unity_Multiply_float(_Property_6CD60F12_Out_0, _ColorMask_272FC211_Out_3, _Multiply_1D98ADD7_Out_2);
                float _Rectangle_ED9580B_Out_3;
                Unity_Rectangle_float((_Fraction_546B575B_Out_1.xy), _Property_2A7DC9C2_Out_0, _Multiply_1D98ADD7_Out_2, _Rectangle_ED9580B_Out_3);
                float _ColorMask_E2051947_Out_3;
                Unity_ColorMask_float((_Rectangle_ED9580B_Out_3.xxx), IsGammaSpace() ? float3(1, 1, 1) : SRGBToLinear(float3(1, 1, 1)), 0, _ColorMask_E2051947_Out_3, 0);
                Gradient _Property_A77D7C54_Out_0 = Gradient_E9031476;
                float4 _SampleGradient_CC875E0D_Out_2;
                Unity_SampleGradient_float(_Property_A77D7C54_Out_0, _Fraction_2A157435_Out_1, _SampleGradient_CC875E0D_Out_2);
                float4 _Multiply_81D019E2_Out_2;
                Unity_Multiply_float((_ColorMask_E2051947_Out_3.xxxx), _SampleGradient_CC875E0D_Out_2, _Multiply_81D019E2_Out_2);
                float _SimpleNoise_940B2896_Out_2;
                Unity_SimpleNoise_float((_Posterize_689219AB_Out_2.xy), 7.28, _SimpleNoise_940B2896_Out_2);
                float _Multiply_EAE41D46_Out_2;
                Unity_Multiply_float(_SimpleNoise_940B2896_Out_2, IN.TimeParameters.x, _Multiply_EAE41D46_Out_2);
                float _Fraction_70F289F6_Out_1;
                Unity_Fraction_float(_Multiply_EAE41D46_Out_2, _Fraction_70F289F6_Out_1);
                float _ColorMask_A073D55B_Out_3;
                Unity_ColorMask_float((_Fraction_70F289F6_Out_1.xxx), IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0)), 0.2, _ColorMask_A073D55B_Out_3, 0.57);
                float _Multiply_7B7A3059_Out_2;
                Unity_Multiply_float(_ColorMask_E2051947_Out_3, _ColorMask_A073D55B_Out_3, _Multiply_7B7A3059_Out_2);
                float _Multiply_B7749CBE_Out_2;
                Unity_Multiply_float(_Multiply_7B7A3059_Out_2, 0.7, _Multiply_B7749CBE_Out_2);
                surface.Color = (_Multiply_81D019E2_Out_2.xyz);
                surface.Alpha = _Multiply_B7749CBE_Out_2;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float4 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyzw = input.texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.texCoord0 = input.interp00.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.uv0 =                         input.texCoord0;
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "ShadowCaster"
            Tags 
            { 
                "LightMode" = "ShadowCaster"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Back
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #pragma multi_compile_instancing
            #define SHADERPASS_SHADOWCASTER
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float Vector1_3713D1A9;
            float Vector1_B683118F;
            float4 Vector4_62004688;
            float Vector1_27B2E7CC;
            float Vector1_6A243453;
            CBUFFER_END
            Gradient Gradient_E9031476_Definition()
            {
                Gradient g;
                g.type = 0;
                g.colorsLength = 5;
                g.alphasLength = 2;
                g.colors[0] = float4(0.4901961, 0.9529412, 0.8601972, 0.2558785);
                g.colors[1] = float4(0.9368421, 0.9921569, 0.5843138, 0.3323568);
                g.colors[2] = float4(0.850422, 0.6580189, 0.8773585, 0.4176547);
                g.colors[3] = float4(0.495283, 0.7701947, 1, 0.4823529);
                g.colors[4] = float4(0.9150943, 0.5740922, 0.7770703, 0.5676509);
                g.colors[5] = float4(0, 0, 0, 0);
                g.colors[6] = float4(0, 0, 0, 0);
                g.colors[7] = float4(0, 0, 0, 0);
                g.alphas[0] = float2(1, 0);
                g.alphas[1] = float2(1, 1);
                g.alphas[2] = float2(0, 0);
                g.alphas[3] = float2(0, 0);
                g.alphas[4] = float2(0, 0);
                g.alphas[5] = float2(0, 0);
                g.alphas[6] = float2(0, 0);
                g.alphas[7] = float2(0, 0);
                return g;
            }
            #define Gradient_E9031476 Gradient_E9031476_Definition()
            TEXTURE2D(Texture2D_E4D35851); SAMPLER(samplerTexture2D_E4D35851); float4 Texture2D_E4D35851_TexelSize;
        
            // Graph Functions
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Minimum_float(float A, float B, out float Out)
            {
                Out = min(A, B);
            };
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Step_float(float Edge, float In, out float Out)
            {
                Out = step(Edge, In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A - B;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Fraction_float4(float4 In, out float4 Out)
            {
                Out = frac(In);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
            {
                Out = floor(In / (1 / Steps)) * (1 / Steps);
            }
            
            
            inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
            {
                return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
            }
            
            inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
            {
                return (1.0-t)*a + (t*b);
            }
            
            
            inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
            {
                float2 i = floor(uv);
                float2 f = frac(uv);
                f = f * f * (3.0 - 2.0 * f);
            
                uv = abs(frac(uv) - 0.5);
                float2 c0 = i + float2(0.0, 0.0);
                float2 c1 = i + float2(1.0, 0.0);
                float2 c2 = i + float2(0.0, 1.0);
                float2 c3 = i + float2(1.0, 1.0);
                float r0 = Unity_SimpleNoise_RandomValue_float(c0);
                float r1 = Unity_SimpleNoise_RandomValue_float(c1);
                float r2 = Unity_SimpleNoise_RandomValue_float(c2);
                float r3 = Unity_SimpleNoise_RandomValue_float(c3);
            
                float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
                float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
                float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
                return t;
            }
            void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
            {
                float t = 0.0;
            
                float freq = pow(2.0, float(0));
                float amp = pow(0.5, float(3-0));
                t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
            
                freq = pow(2.0, float(1));
                amp = pow(0.5, float(3-1));
                t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
            
                freq = pow(2.0, float(2));
                amp = pow(0.5, float(3-2));
                t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
            
                Out = t;
            }
            
            void Unity_Fraction_float(float In, out float Out)
            {
                Out = frac(In);
            }
            
            void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
            {
                float Distance = distance(MaskColor, In);
                Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
            }
            
            void Unity_Rectangle_float(float2 UV, float Width, float Height, out float Out)
            {
                float2 d = abs(UV * 2 - 1) - float2(Width, Height);
                d = 1 - d / fwidth(d);
                Out = saturate(min(d.x, d.y));
            }
        
            // Graph Vertex
            // GraphVertex: <None>
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float4 uv0;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _UV_C370CDB7_Out_0 = IN.uv0;
                float _Split_1F68BB03_R_1 = _UV_C370CDB7_Out_0[0];
                float _Split_1F68BB03_G_2 = _UV_C370CDB7_Out_0[1];
                float _Split_1F68BB03_B_3 = _UV_C370CDB7_Out_0[2];
                float _Split_1F68BB03_A_4 = _UV_C370CDB7_Out_0[3];
                float4 _Property_B84A3F19_Out_0 = Vector4_62004688;
                float _Split_855822D1_R_1 = _Property_B84A3F19_Out_0[0];
                float _Split_855822D1_G_2 = _Property_B84A3F19_Out_0[1];
                float _Split_855822D1_B_3 = _Property_B84A3F19_Out_0[2];
                float _Split_855822D1_A_4 = _Property_B84A3F19_Out_0[3];
                float _Maximum_D6EF91E4_Out_2;
                Unity_Maximum_float(_Split_1F68BB03_R_1, _Split_855822D1_R_1, _Maximum_D6EF91E4_Out_2);
                float _Minimum_825E3952_Out_2;
                Unity_Minimum_float(_Split_1F68BB03_R_1, _Split_855822D1_B_3, _Minimum_825E3952_Out_2);
                float _Subtract_C4C37B82_Out_2;
                Unity_Subtract_float(_Maximum_D6EF91E4_Out_2, _Minimum_825E3952_Out_2, _Subtract_C4C37B82_Out_2);
                float _Step_A68487AD_Out_2;
                Unity_Step_float(_Subtract_C4C37B82_Out_2, 0, _Step_A68487AD_Out_2);
                float _Maximum_468BF54A_Out_2;
                Unity_Maximum_float(_Split_1F68BB03_G_2, _Split_855822D1_G_2, _Maximum_468BF54A_Out_2);
                float _Minimum_40DD615F_Out_2;
                Unity_Minimum_float(_Split_1F68BB03_G_2, _Split_855822D1_A_4, _Minimum_40DD615F_Out_2);
                float _Subtract_A65B73C4_Out_2;
                Unity_Subtract_float(_Maximum_468BF54A_Out_2, _Minimum_40DD615F_Out_2, _Subtract_A65B73C4_Out_2);
                float _Step_5BC0B879_Out_2;
                Unity_Step_float(_Subtract_A65B73C4_Out_2, 0, _Step_5BC0B879_Out_2);
                float _Multiply_39963897_Out_2;
                Unity_Multiply_float(_Step_A68487AD_Out_2, _Step_5BC0B879_Out_2, _Multiply_39963897_Out_2);
                float4 _Subtract_E19921F4_Out_2;
                Unity_Subtract_float4(_UV_C370CDB7_Out_0, float4(0, 0, 0, 0), _Subtract_E19921F4_Out_2);
                float4 _Multiply_AB278265_Out_2;
                Unity_Multiply_float(_Subtract_E19921F4_Out_2, float4(5, 1, 1, 1), _Multiply_AB278265_Out_2);
                float4 _Fraction_BF583C1C_Out_1;
                Unity_Fraction_float4(_Multiply_AB278265_Out_2, _Fraction_BF583C1C_Out_1);
                float4 _Multiply_6C930300_Out_2;
                Unity_Multiply_float(_Fraction_BF583C1C_Out_1, float4(0.2, 1, 1, 1), _Multiply_6C930300_Out_2);
                float4 _Add_CF76F001_Out_2;
                Unity_Add_float4(_Multiply_6C930300_Out_2, float4(0, 0, 0, 0), _Add_CF76F001_Out_2);
                float4 _Multiply_2A269DB1_Out_2;
                Unity_Multiply_float((_Multiply_39963897_Out_2.xxxx), _Add_CF76F001_Out_2, _Multiply_2A269DB1_Out_2);
                float4 _Add_7D6AE11_Out_2;
                Unity_Add_float4(_Multiply_2A269DB1_Out_2, float4(0, 0, 0, 0), _Add_7D6AE11_Out_2);
                float _Property_723DCD97_Out_0 = Vector1_27B2E7CC;
                float _Property_A0F8AF92_Out_0 = Vector1_6A243453;
                float _Multiply_C92B5029_Out_2;
                Unity_Multiply_float(_Property_723DCD97_Out_0, _Property_A0F8AF92_Out_0, _Multiply_C92B5029_Out_2);
                float4 _Vector4_13A9A5E5_Out_0 = float4(_Property_723DCD97_Out_0, _Multiply_C92B5029_Out_2, _Property_723DCD97_Out_0, _Property_723DCD97_Out_0);
                float4 _Multiply_34667561_Out_2;
                Unity_Multiply_float(_Add_7D6AE11_Out_2, _Vector4_13A9A5E5_Out_0, _Multiply_34667561_Out_2);
                float4 _Fraction_546B575B_Out_1;
                Unity_Fraction_float4(_Multiply_34667561_Out_2, _Fraction_546B575B_Out_1);
                float _Property_2A7DC9C2_Out_0 = Vector1_3713D1A9;
                float _Property_6CD60F12_Out_0 = Vector1_B683118F;
                float4 _UV_91F5080D_Out_0 = IN.uv0;
                float _Property_E5B773C2_Out_0 = Vector1_27B2E7CC;
                float4 _Vector4_E968D17C_Out_0 = float4(_Property_E5B773C2_Out_0, _Property_E5B773C2_Out_0, _Property_E5B773C2_Out_0, _Property_E5B773C2_Out_0);
                float4 _Posterize_689219AB_Out_2;
                Unity_Posterize_float4(_UV_91F5080D_Out_0, _Vector4_E968D17C_Out_0, _Posterize_689219AB_Out_2);
                float _SimpleNoise_8270394E_Out_2;
                Unity_SimpleNoise_float((_Posterize_689219AB_Out_2.xy), 35.1, _SimpleNoise_8270394E_Out_2);
                float _Multiply_7A4588D0_Out_2;
                Unity_Multiply_float(_SimpleNoise_8270394E_Out_2, IN.TimeParameters.x, _Multiply_7A4588D0_Out_2);
                float _Fraction_2A157435_Out_1;
                Unity_Fraction_float(_Multiply_7A4588D0_Out_2, _Fraction_2A157435_Out_1);
                float _ColorMask_272FC211_Out_3;
                Unity_ColorMask_float((_Fraction_2A157435_Out_1.xxx), IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0)), 0.2, _ColorMask_272FC211_Out_3, 0.57);
                float _Multiply_1D98ADD7_Out_2;
                Unity_Multiply_float(_Property_6CD60F12_Out_0, _ColorMask_272FC211_Out_3, _Multiply_1D98ADD7_Out_2);
                float _Rectangle_ED9580B_Out_3;
                Unity_Rectangle_float((_Fraction_546B575B_Out_1.xy), _Property_2A7DC9C2_Out_0, _Multiply_1D98ADD7_Out_2, _Rectangle_ED9580B_Out_3);
                float _ColorMask_E2051947_Out_3;
                Unity_ColorMask_float((_Rectangle_ED9580B_Out_3.xxx), IsGammaSpace() ? float3(1, 1, 1) : SRGBToLinear(float3(1, 1, 1)), 0, _ColorMask_E2051947_Out_3, 0);
                float _SimpleNoise_940B2896_Out_2;
                Unity_SimpleNoise_float((_Posterize_689219AB_Out_2.xy), 7.28, _SimpleNoise_940B2896_Out_2);
                float _Multiply_EAE41D46_Out_2;
                Unity_Multiply_float(_SimpleNoise_940B2896_Out_2, IN.TimeParameters.x, _Multiply_EAE41D46_Out_2);
                float _Fraction_70F289F6_Out_1;
                Unity_Fraction_float(_Multiply_EAE41D46_Out_2, _Fraction_70F289F6_Out_1);
                float _ColorMask_A073D55B_Out_3;
                Unity_ColorMask_float((_Fraction_70F289F6_Out_1.xxx), IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0)), 0.2, _ColorMask_A073D55B_Out_3, 0.57);
                float _Multiply_7B7A3059_Out_2;
                Unity_Multiply_float(_ColorMask_E2051947_Out_3, _ColorMask_A073D55B_Out_3, _Multiply_7B7A3059_Out_2);
                float _Multiply_B7749CBE_Out_2;
                Unity_Multiply_float(_Multiply_7B7A3059_Out_2, 0.7, _Multiply_B7749CBE_Out_2);
                surface.Alpha = _Multiply_B7749CBE_Out_2;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float4 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyzw = input.texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.texCoord0 = input.interp00.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.uv0 =                         input.texCoord0;
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "DepthOnly"
            Tags 
            { 
                "LightMode" = "DepthOnly"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Back
            ZTest LEqual
            ZWrite On
            ColorMask 0
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #pragma multi_compile_instancing
            #define SHADERPASS_DEPTHONLY
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float Vector1_3713D1A9;
            float Vector1_B683118F;
            float4 Vector4_62004688;
            float Vector1_27B2E7CC;
            float Vector1_6A243453;
            CBUFFER_END
            Gradient Gradient_E9031476_Definition()
            {
                Gradient g;
                g.type = 0;
                g.colorsLength = 5;
                g.alphasLength = 2;
                g.colors[0] = float4(0.4901961, 0.9529412, 0.8601972, 0.2558785);
                g.colors[1] = float4(0.9368421, 0.9921569, 0.5843138, 0.3323568);
                g.colors[2] = float4(0.850422, 0.6580189, 0.8773585, 0.4176547);
                g.colors[3] = float4(0.495283, 0.7701947, 1, 0.4823529);
                g.colors[4] = float4(0.9150943, 0.5740922, 0.7770703, 0.5676509);
                g.colors[5] = float4(0, 0, 0, 0);
                g.colors[6] = float4(0, 0, 0, 0);
                g.colors[7] = float4(0, 0, 0, 0);
                g.alphas[0] = float2(1, 0);
                g.alphas[1] = float2(1, 1);
                g.alphas[2] = float2(0, 0);
                g.alphas[3] = float2(0, 0);
                g.alphas[4] = float2(0, 0);
                g.alphas[5] = float2(0, 0);
                g.alphas[6] = float2(0, 0);
                g.alphas[7] = float2(0, 0);
                return g;
            }
            #define Gradient_E9031476 Gradient_E9031476_Definition()
            TEXTURE2D(Texture2D_E4D35851); SAMPLER(samplerTexture2D_E4D35851); float4 Texture2D_E4D35851_TexelSize;
        
            // Graph Functions
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Minimum_float(float A, float B, out float Out)
            {
                Out = min(A, B);
            };
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Step_float(float Edge, float In, out float Out)
            {
                Out = step(Edge, In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A - B;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Fraction_float4(float4 In, out float4 Out)
            {
                Out = frac(In);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
            {
                Out = floor(In / (1 / Steps)) * (1 / Steps);
            }
            
            
            inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
            {
                return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
            }
            
            inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
            {
                return (1.0-t)*a + (t*b);
            }
            
            
            inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
            {
                float2 i = floor(uv);
                float2 f = frac(uv);
                f = f * f * (3.0 - 2.0 * f);
            
                uv = abs(frac(uv) - 0.5);
                float2 c0 = i + float2(0.0, 0.0);
                float2 c1 = i + float2(1.0, 0.0);
                float2 c2 = i + float2(0.0, 1.0);
                float2 c3 = i + float2(1.0, 1.0);
                float r0 = Unity_SimpleNoise_RandomValue_float(c0);
                float r1 = Unity_SimpleNoise_RandomValue_float(c1);
                float r2 = Unity_SimpleNoise_RandomValue_float(c2);
                float r3 = Unity_SimpleNoise_RandomValue_float(c3);
            
                float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
                float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
                float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
                return t;
            }
            void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
            {
                float t = 0.0;
            
                float freq = pow(2.0, float(0));
                float amp = pow(0.5, float(3-0));
                t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
            
                freq = pow(2.0, float(1));
                amp = pow(0.5, float(3-1));
                t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
            
                freq = pow(2.0, float(2));
                amp = pow(0.5, float(3-2));
                t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
            
                Out = t;
            }
            
            void Unity_Fraction_float(float In, out float Out)
            {
                Out = frac(In);
            }
            
            void Unity_ColorMask_float(float3 In, float3 MaskColor, float Range, out float Out, float Fuzziness)
            {
                float Distance = distance(MaskColor, In);
                Out = saturate(1 - (Distance - Range) / max(Fuzziness, 1e-5));
            }
            
            void Unity_Rectangle_float(float2 UV, float Width, float Height, out float Out)
            {
                float2 d = abs(UV * 2 - 1) - float2(Width, Height);
                d = 1 - d / fwidth(d);
                Out = saturate(min(d.x, d.y));
            }
        
            // Graph Vertex
            // GraphVertex: <None>
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float4 uv0;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _UV_C370CDB7_Out_0 = IN.uv0;
                float _Split_1F68BB03_R_1 = _UV_C370CDB7_Out_0[0];
                float _Split_1F68BB03_G_2 = _UV_C370CDB7_Out_0[1];
                float _Split_1F68BB03_B_3 = _UV_C370CDB7_Out_0[2];
                float _Split_1F68BB03_A_4 = _UV_C370CDB7_Out_0[3];
                float4 _Property_B84A3F19_Out_0 = Vector4_62004688;
                float _Split_855822D1_R_1 = _Property_B84A3F19_Out_0[0];
                float _Split_855822D1_G_2 = _Property_B84A3F19_Out_0[1];
                float _Split_855822D1_B_3 = _Property_B84A3F19_Out_0[2];
                float _Split_855822D1_A_4 = _Property_B84A3F19_Out_0[3];
                float _Maximum_D6EF91E4_Out_2;
                Unity_Maximum_float(_Split_1F68BB03_R_1, _Split_855822D1_R_1, _Maximum_D6EF91E4_Out_2);
                float _Minimum_825E3952_Out_2;
                Unity_Minimum_float(_Split_1F68BB03_R_1, _Split_855822D1_B_3, _Minimum_825E3952_Out_2);
                float _Subtract_C4C37B82_Out_2;
                Unity_Subtract_float(_Maximum_D6EF91E4_Out_2, _Minimum_825E3952_Out_2, _Subtract_C4C37B82_Out_2);
                float _Step_A68487AD_Out_2;
                Unity_Step_float(_Subtract_C4C37B82_Out_2, 0, _Step_A68487AD_Out_2);
                float _Maximum_468BF54A_Out_2;
                Unity_Maximum_float(_Split_1F68BB03_G_2, _Split_855822D1_G_2, _Maximum_468BF54A_Out_2);
                float _Minimum_40DD615F_Out_2;
                Unity_Minimum_float(_Split_1F68BB03_G_2, _Split_855822D1_A_4, _Minimum_40DD615F_Out_2);
                float _Subtract_A65B73C4_Out_2;
                Unity_Subtract_float(_Maximum_468BF54A_Out_2, _Minimum_40DD615F_Out_2, _Subtract_A65B73C4_Out_2);
                float _Step_5BC0B879_Out_2;
                Unity_Step_float(_Subtract_A65B73C4_Out_2, 0, _Step_5BC0B879_Out_2);
                float _Multiply_39963897_Out_2;
                Unity_Multiply_float(_Step_A68487AD_Out_2, _Step_5BC0B879_Out_2, _Multiply_39963897_Out_2);
                float4 _Subtract_E19921F4_Out_2;
                Unity_Subtract_float4(_UV_C370CDB7_Out_0, float4(0, 0, 0, 0), _Subtract_E19921F4_Out_2);
                float4 _Multiply_AB278265_Out_2;
                Unity_Multiply_float(_Subtract_E19921F4_Out_2, float4(5, 1, 1, 1), _Multiply_AB278265_Out_2);
                float4 _Fraction_BF583C1C_Out_1;
                Unity_Fraction_float4(_Multiply_AB278265_Out_2, _Fraction_BF583C1C_Out_1);
                float4 _Multiply_6C930300_Out_2;
                Unity_Multiply_float(_Fraction_BF583C1C_Out_1, float4(0.2, 1, 1, 1), _Multiply_6C930300_Out_2);
                float4 _Add_CF76F001_Out_2;
                Unity_Add_float4(_Multiply_6C930300_Out_2, float4(0, 0, 0, 0), _Add_CF76F001_Out_2);
                float4 _Multiply_2A269DB1_Out_2;
                Unity_Multiply_float((_Multiply_39963897_Out_2.xxxx), _Add_CF76F001_Out_2, _Multiply_2A269DB1_Out_2);
                float4 _Add_7D6AE11_Out_2;
                Unity_Add_float4(_Multiply_2A269DB1_Out_2, float4(0, 0, 0, 0), _Add_7D6AE11_Out_2);
                float _Property_723DCD97_Out_0 = Vector1_27B2E7CC;
                float _Property_A0F8AF92_Out_0 = Vector1_6A243453;
                float _Multiply_C92B5029_Out_2;
                Unity_Multiply_float(_Property_723DCD97_Out_0, _Property_A0F8AF92_Out_0, _Multiply_C92B5029_Out_2);
                float4 _Vector4_13A9A5E5_Out_0 = float4(_Property_723DCD97_Out_0, _Multiply_C92B5029_Out_2, _Property_723DCD97_Out_0, _Property_723DCD97_Out_0);
                float4 _Multiply_34667561_Out_2;
                Unity_Multiply_float(_Add_7D6AE11_Out_2, _Vector4_13A9A5E5_Out_0, _Multiply_34667561_Out_2);
                float4 _Fraction_546B575B_Out_1;
                Unity_Fraction_float4(_Multiply_34667561_Out_2, _Fraction_546B575B_Out_1);
                float _Property_2A7DC9C2_Out_0 = Vector1_3713D1A9;
                float _Property_6CD60F12_Out_0 = Vector1_B683118F;
                float4 _UV_91F5080D_Out_0 = IN.uv0;
                float _Property_E5B773C2_Out_0 = Vector1_27B2E7CC;
                float4 _Vector4_E968D17C_Out_0 = float4(_Property_E5B773C2_Out_0, _Property_E5B773C2_Out_0, _Property_E5B773C2_Out_0, _Property_E5B773C2_Out_0);
                float4 _Posterize_689219AB_Out_2;
                Unity_Posterize_float4(_UV_91F5080D_Out_0, _Vector4_E968D17C_Out_0, _Posterize_689219AB_Out_2);
                float _SimpleNoise_8270394E_Out_2;
                Unity_SimpleNoise_float((_Posterize_689219AB_Out_2.xy), 35.1, _SimpleNoise_8270394E_Out_2);
                float _Multiply_7A4588D0_Out_2;
                Unity_Multiply_float(_SimpleNoise_8270394E_Out_2, IN.TimeParameters.x, _Multiply_7A4588D0_Out_2);
                float _Fraction_2A157435_Out_1;
                Unity_Fraction_float(_Multiply_7A4588D0_Out_2, _Fraction_2A157435_Out_1);
                float _ColorMask_272FC211_Out_3;
                Unity_ColorMask_float((_Fraction_2A157435_Out_1.xxx), IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0)), 0.2, _ColorMask_272FC211_Out_3, 0.57);
                float _Multiply_1D98ADD7_Out_2;
                Unity_Multiply_float(_Property_6CD60F12_Out_0, _ColorMask_272FC211_Out_3, _Multiply_1D98ADD7_Out_2);
                float _Rectangle_ED9580B_Out_3;
                Unity_Rectangle_float((_Fraction_546B575B_Out_1.xy), _Property_2A7DC9C2_Out_0, _Multiply_1D98ADD7_Out_2, _Rectangle_ED9580B_Out_3);
                float _ColorMask_E2051947_Out_3;
                Unity_ColorMask_float((_Rectangle_ED9580B_Out_3.xxx), IsGammaSpace() ? float3(1, 1, 1) : SRGBToLinear(float3(1, 1, 1)), 0, _ColorMask_E2051947_Out_3, 0);
                float _SimpleNoise_940B2896_Out_2;
                Unity_SimpleNoise_float((_Posterize_689219AB_Out_2.xy), 7.28, _SimpleNoise_940B2896_Out_2);
                float _Multiply_EAE41D46_Out_2;
                Unity_Multiply_float(_SimpleNoise_940B2896_Out_2, IN.TimeParameters.x, _Multiply_EAE41D46_Out_2);
                float _Fraction_70F289F6_Out_1;
                Unity_Fraction_float(_Multiply_EAE41D46_Out_2, _Fraction_70F289F6_Out_1);
                float _ColorMask_A073D55B_Out_3;
                Unity_ColorMask_float((_Fraction_70F289F6_Out_1.xxx), IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0)), 0.2, _ColorMask_A073D55B_Out_3, 0.57);
                float _Multiply_7B7A3059_Out_2;
                Unity_Multiply_float(_ColorMask_E2051947_Out_3, _ColorMask_A073D55B_Out_3, _Multiply_7B7A3059_Out_2);
                float _Multiply_B7749CBE_Out_2;
                Unity_Multiply_float(_Multiply_7B7A3059_Out_2, 0.7, _Multiply_B7749CBE_Out_2);
                surface.Alpha = _Multiply_B7749CBE_Out_2;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float4 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyzw = input.texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.texCoord0 = input.interp00.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.uv0 =                         input.texCoord0;
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
            ENDHLSL
        }
        
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
