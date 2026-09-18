//Maya ASCII 2016R2 scene
//Name: breakingcrate_dest_break.ma
//Last modified: Wed, Jun 07, 2017 09:38:44 PM
//Codeset: 1252
file -rdi 1 -ns ":" -rfn "breakingcrate_destRN" -op "v=0;" -typ "mayaAscii" "valve:///models/gameplay/maya/breakingcrate_dest.ma";
file -rdi 2 -ns "breakingcrate_vmat1" -rfn "breakingcrate_vmatRN1" -typ "mayaAscii"
		 "%VTOOLS%/maya/global/python/Materials/dota_hero_shaderfx.ma";
file -r -ns ":" -dr 1 -rfn "breakingcrate_destRN" -op "v=0;" -typ "mayaAscii" "valve:///models/gameplay/maya/breakingcrate_dest.ma";
requires maya "2016R2";
requires -nodeType "vstExportNode" "PVstExportNode.py" "2.1.0";
requires -nodeType "bulletRigidBodyShape" -nodeType "bulletSolverShape" -dataType "bulletSolverData"
		 -dataType "bulletRigidBodyData" -dataType "bulletSoftBodyData" -dataType "bulletSoftConstraintData"
		 -dataType "BulletRigidBodyConstraintData" -dataType "bulletColliderData" -dataType "bulletRigidInitialStateGeometry"
		 -dataType "bulletMotionsStates" -dataType "bulletCollisionShapes" "bullet" "Mar  2 2016";
requires "stereoCamera" "10.0";
requires "stereoCamera" "10.0";
currentUnit -l centimeter -a degree -t ntsc;
fileInfo "application" "maya";
fileInfo "product" "Maya 2016";
fileInfo "version" "2016 Extension 2";
fileInfo "cutIdentifier" "201603022110-988944-2";
fileInfo "osv" "Microsoft Windows 8 Business Edition, 64-bit  (Build 9200)\n";
createNode transform -s -n "persp";
	rename -uid "2DBAEC87-46A1-9FDC-21F1-FA8B23DCAD46";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 110.53965330962556 212.97497340198521 -159.85883517959516 ;
	setAttr ".r" -type "double3" -44.738352729590403 141.39999999993674 0 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "427E4F6F-4916-10BE-AB86-63B29C5C671D";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 242.72812806953584;
	setAttr ".imn" -type "string" "persp";
	setAttr ".den" -type "string" "persp_depth";
	setAttr ".man" -type "string" "persp_mask";
	setAttr ".hc" -type "string" "viewSet -p %camera";
createNode transform -s -n "top";
	rename -uid "D519D446-4567-302E-F014-379599F36DCD";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 1000.1 0 ;
	setAttr ".r" -type "double3" -89.999999999999986 0 0 ;
createNode camera -s -n "topShape" -p "top";
	rename -uid "23A6AC83-4623-E0E8-9BEE-12854DC410B7";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 1000.1;
	setAttr ".ow" 30;
	setAttr ".imn" -type "string" "top";
	setAttr ".den" -type "string" "top_depth";
	setAttr ".man" -type "string" "top_mask";
	setAttr ".hc" -type "string" "viewSet -t %camera";
	setAttr ".o" yes;
createNode transform -s -n "front";
	rename -uid "525C93E2-4610-0689-2044-4F99A1E6BADF";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 0 1000.1 ;
createNode camera -s -n "frontShape" -p "front";
	rename -uid "665D576C-4192-9447-0FEC-06A30ADD70C0";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 1000.1;
	setAttr ".ow" 30;
	setAttr ".imn" -type "string" "front";
	setAttr ".den" -type "string" "front_depth";
	setAttr ".man" -type "string" "front_mask";
	setAttr ".hc" -type "string" "viewSet -f %camera";
	setAttr ".o" yes;
createNode transform -s -n "side";
	rename -uid "83B53093-4442-F159-CD82-B8865D0AAB77";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 1000.1124986720247 -12.28724121212886 9.4639496261416021 ;
	setAttr ".r" -type "double3" 0 89.999999999999986 0 ;
createNode camera -s -n "sideShape" -p "side";
	rename -uid "C83E9EED-4BAF-0A7F-A064-DDAC156B0CA5";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 1000.1124986720245;
	setAttr ".ow" 122.08495017722379;
	setAttr ".imn" -type "string" "side";
	setAttr ".den" -type "string" "side_depth";
	setAttr ".man" -type "string" "side_mask";
	setAttr ".tp" -type "double3" 0 -5 0 ;
	setAttr ".hc" -type "string" "viewSet -s %camera";
	setAttr ".o" yes;
createNode transform -n "bulletSolver1";
	rename -uid "725E7AB0-4E10-A51F-2FE4-158184AEA074";
createNode bulletSolverShape -n "bulletSolverShape1" -p "bulletSolver1";
	rename -uid "986B5D2E-481B-46F5-5A37-86A5C9A0529D";
	setAttr -k off ".v";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".gr" -type "float3" 0 -980 0 ;
	setAttr -s 14 ".rb";
	setAttr ".sacc" 2;
	setAttr ".mni" 64;
createNode transform -n "ground";
	rename -uid "5C2945F4-4FE7-6763-125D-62A49180C0BF";
	setAttr ".s" -type "double3" 1500 10 1500 ;
createNode mesh -n "groundShape" -p "ground";
	rename -uid "5C4A3A11-434E-B5D9-CABA-74B5244B764C";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 14 ".uvst[0].uvsp[0:13]" -type "float2" 0.375 0 0.625 0 0.375
		 0.25 0.625 0.25 0.375 0.5 0.625 0.5 0.375 0.75 0.625 0.75 0.375 1 0.625 1 0.875 0
		 0.875 0.25 0.125 0 0.125 0.25;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -0.5 -0.5 0.5 0.5 -0.5 0.5 -0.5 0.5 0.5 0.5 0.5 0.5
		 -0.5 0.5 -0.5 0.5 0.5 -0.5 -0.5 -0.5 -0.5 0.5 -0.5 -0.5;
	setAttr -s 12 ".ed[0:11]"  0 1 0 2 3 0 4 5 0 6 7 0 0 2 0 1 3 0 2 4 0
		 3 5 0 4 6 0 5 7 0 6 0 0 7 1 0;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 5 -2 -5
		mu 0 4 0 1 3 2
		f 4 1 7 -3 -7
		mu 0 4 2 3 5 4
		f 4 2 9 -4 -9
		mu 0 4 4 5 7 6
		f 4 3 11 -1 -11
		mu 0 4 6 7 9 8
		f 4 -12 -10 -8 -6
		mu 0 4 1 10 11 3
		f 4 10 4 6 8
		mu 0 4 12 0 2 13;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape14" -p "ground";
	rename -uid "CA7278E7-4F48-7734-486B-84AB5C72BE83";
	setAttr -k off ".v";
	setAttr ".fric" 0.34999999403953552;
	setAttr ".colshtyp" 4;
	setAttr ".itrs" -type "float3" 0 -5 0 ;
createNode fosterParent -n "breakingcrate_destRNfosterParent1";
	rename -uid "180AAFF3-41F3-4397-944F-58A8FDB93B12";
createNode bulletRigidBodyShape -n "bulletRigidBodyShape13" -p "breakingcrate_destRNfosterParent1";
	rename -uid "3DE25E5B-4D65-54B8-8433-D28C1EF723AB";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 550 0 ;
	setAttr ".iav" -type "float3" 0 0 500 ;
	setAttr ".com" -type "float3" -36.443199 43.402206 9.6520414 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 75.3050537109375;
	setAttr ".rad" 37.65252685546875;
	setAttr ".ext" -type "float3" 11.008917 75.305054 56.597183 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape12" -p "breakingcrate_destRNfosterParent1";
	rename -uid "C1E8A0D5-43C3-17E9-A4AA-67AC732B7AE7";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 650 0 ;
	setAttr ".iav" -type "float3" 0 150 0 ;
	setAttr ".com" -type "float3" -36.443199 43.402214 -13.401755 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 75.3050537109375;
	setAttr ".rad" 37.65252685546875;
	setAttr ".ext" -type "float3" 11.008917 75.305054 49.097755 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape11" -p "breakingcrate_destRNfosterParent1";
	rename -uid "E1FE46C6-4C0E-CE94-4EF9-45BD0E081F97";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 400 0 ;
	setAttr ".iav" -type "float3" 0 125 265 ;
	setAttr ".com" -type "float3" -8.6867132 82.209763 -0.0014343262 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 74.777976989746094;
	setAttr ".rad" 37.388988494873047;
	setAttr ".ext" -type "float3" 55.741722 7.6908035 74.777977 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape10" -p "breakingcrate_destRNfosterParent1";
	rename -uid "CC749DDE-417B-1BF7-CDE3-65B37D8F6112";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 400 0 ;
	setAttr ".iav" -type "float3" 0 0 175 ;
	setAttr ".com" -type "float3" -6.5793991 58.118282 -36.956402 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 61.915313720703125;
	setAttr ".rad" 30.957656860351562;
	setAttr ".ext" -type "float3" 61.915314 45.872932 9.9825134 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape9" -p "breakingcrate_destRNfosterParent1";
	rename -uid "4DAD52D6-4221-0FAF-8786-43A964F24070";
	setAttr -k off ".v";
	setAttr ".com" -type "float3" -17.773495 25.081089 -37.24966 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 40.061027526855469;
	setAttr ".rad" 20.030513763427734;
	setAttr ".ext" -type "float3" 40.061028 38.662811 9.3959961 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape8" -p "breakingcrate_destRNfosterParent1";
	rename -uid "6096C671-4522-4060-BFE9-0D9970111797";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 0 600 ;
	setAttr ".com" -type "float3" 7.1549768 43.402214 -36.956402 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 75.074111938476562;
	setAttr ".rad" 37.537055969238281;
	setAttr ".ext" -type "float3" 60.76416 75.074112 9.9825134 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape7" -p "breakingcrate_destRNfosterParent1";
	rename -uid "F12171AC-4C17-FE96-710D-DD94EE2AB2C5";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 550 0 ;
	setAttr ".com" -type "float3" 37.029716 43.402214 -13.78267 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 75.3050537109375;
	setAttr ".rad" 37.65252685546875;
	setAttr ".ext" -type "float3" 9.8358841 75.305054 48.33593 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape6" -p "breakingcrate_destRNfosterParent1";
	rename -uid "32AF9607-4021-CC82-CD9A-489316610EDA";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 550 0 ;
	setAttr ".com" -type "float3" 37.029716 43.402214 12.137182 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 75.305068969726563;
	setAttr ".rad" 37.652534484863281;
	setAttr ".ext" -type "float3" 9.8358841 75.305069 51.626904 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape5" -p "breakingcrate_destRNfosterParent1";
	rename -uid "BA744A8E-4E2E-517C-D085-F7A6C442F796";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 620 50 ;
	setAttr ".iav" -type "float3" 0 250 50 ;
	setAttr ".com" -type "float3" 8.9017897 82.218948 -0.5865078 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 77.59527587890625;
	setAttr ".rad" 38.797637939453125;
	setAttr ".ext" -type "float3" 61.163483 7.6724243 77.595276 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape4" -p "breakingcrate_destRNfosterParent1";
	rename -uid "D29CD78C-44A4-8E74-A357-18A956F9D460";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 600 0 ;
	setAttr ".com" -type "float3" 7.6549129 43.402222 36.663143 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 75.411956787109375;
	setAttr ".rad" 37.705978393554688;
	setAttr ".ext" -type "float3" 61.537045 75.411957 9.9825115 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape3" -p "breakingcrate_destRNfosterParent1";
	rename -uid "DADFA19B-4B57-5E0E-D051-AB8756280B30";
	setAttr -k off ".v";
	setAttr ".com" -type "float3" -13.20715 23.346712 36.663143 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 52.192131042480469;
	setAttr ".rad" 26.096065521240234;
	setAttr ".ext" -type "float3" 52.192131 35.30093 9.9825115 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape2" -p "breakingcrate_destRNfosterParent1";
	rename -uid "0E0B880F-4ED1-66D0-F3A6-A9875ABDF62A";
	setAttr -k off ".v";
	setAttr ".com" -type "float3" -10.399111 55.005131 36.663143 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 56.202693939208984;
	setAttr ".rad" 28.101346969604492;
	setAttr ".ext" -type "float3" 56.202694 52.206139 9.9825115 ;
createNode bulletRigidBodyShape -n "bulletRigidBodyShape1" -p "breakingcrate_destRNfosterParent1";
	rename -uid "FA6AB1BB-4ADC-C7E2-53FA-E78E69A6007A";
	setAttr -k off ".v";
	setAttr ".iv" -type "float3" 0 650 0 ;
	setAttr ".iav" -type "float3" 0 450 0 ;
	setAttr ".ms" 5;
	setAttr ".com" -type "float3" 0.58651543 3.519098 0 ;
	setAttr ".fric" 0.75;
	setAttr ".colshtyp" 9;
	setAttr ".bdytyp" 2;
	setAttr ".len" 74.8887939453125;
	setAttr ".rad" 37.44439697265625;
	setAttr ".ext" -type "float3" 74.288177 7.2992015 74.888794 ;
createNode lightLinker -s -n "lightLinker1";
	rename -uid "4820DD50-4B73-903C-D913-20A94B21F815";
	setAttr -s 4 ".lnk";
	setAttr -s 4 ".slnk";
createNode shapeEditorManager -n "shapeEditorManager";
	rename -uid "B3EFC437-4DF8-976F-4C52-8E9299789E54";
createNode poseInterpolatorManager -n "poseInterpolatorManager";
	rename -uid "37FA178E-48E0-0E33-3F9A-B2A0ED099168";
createNode displayLayerManager -n "layerManager";
	rename -uid "93E5CF5D-4E17-0C56-D440-1DBCFE813F54";
createNode displayLayer -n "defaultLayer";
	rename -uid "8CFE2450-464D-2194-278D-81BE5CD0B390";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "DD09D443-43F7-AFE5-3A7A-4C98A54F723C";
createNode renderLayer -n "defaultRenderLayer";
	rename -uid "DA187A26-4ACA-4DD5-DA21-B48A46FB3AA8";
	setAttr ".g" yes;
createNode reference -n "breakingcrate_destRN";
	rename -uid "97493A36-4DEB-D271-316D-CF80E0699E17";
	setAttr -s 131 ".phl";
	setAttr ".phl[1]" 0;
	setAttr ".phl[2]" 0;
	setAttr ".phl[3]" 0;
	setAttr ".phl[4]" 0;
	setAttr ".phl[5]" 0;
	setAttr ".phl[6]" 0;
	setAttr ".phl[7]" 0;
	setAttr ".phl[8]" 0;
	setAttr ".phl[9]" 0;
	setAttr ".phl[10]" 0;
	setAttr ".phl[11]" 0;
	setAttr ".phl[12]" 0;
	setAttr ".phl[13]" 0;
	setAttr ".phl[14]" 0;
	setAttr ".phl[15]" 0;
	setAttr ".phl[16]" 0;
	setAttr ".phl[17]" 0;
	setAttr ".phl[18]" 0;
	setAttr ".phl[19]" 0;
	setAttr ".phl[20]" 0;
	setAttr ".phl[21]" 0;
	setAttr ".phl[22]" 0;
	setAttr ".phl[23]" 0;
	setAttr ".phl[24]" 0;
	setAttr ".phl[25]" 0;
	setAttr ".phl[26]" 0;
	setAttr ".phl[27]" 0;
	setAttr ".phl[28]" 0;
	setAttr ".phl[29]" 0;
	setAttr ".phl[30]" 0;
	setAttr ".phl[31]" 0;
	setAttr ".phl[32]" 0;
	setAttr ".phl[33]" 0;
	setAttr ".phl[34]" 0;
	setAttr ".phl[35]" 0;
	setAttr ".phl[36]" 0;
	setAttr ".phl[37]" 0;
	setAttr ".phl[38]" 0;
	setAttr ".phl[39]" 0;
	setAttr ".phl[40]" 0;
	setAttr ".phl[41]" 0;
	setAttr ".phl[42]" 0;
	setAttr ".phl[43]" 0;
	setAttr ".phl[44]" 0;
	setAttr ".phl[45]" 0;
	setAttr ".phl[46]" 0;
	setAttr ".phl[47]" 0;
	setAttr ".phl[48]" 0;
	setAttr ".phl[49]" 0;
	setAttr ".phl[50]" 0;
	setAttr ".phl[51]" 0;
	setAttr ".phl[52]" 0;
	setAttr ".phl[53]" 0;
	setAttr ".phl[54]" 0;
	setAttr ".phl[55]" 0;
	setAttr ".phl[56]" 0;
	setAttr ".phl[57]" 0;
	setAttr ".phl[58]" 0;
	setAttr ".phl[59]" 0;
	setAttr ".phl[60]" 0;
	setAttr ".phl[61]" 0;
	setAttr ".phl[62]" 0;
	setAttr ".phl[63]" 0;
	setAttr ".phl[64]" 0;
	setAttr ".phl[65]" 0;
	setAttr ".phl[66]" 0;
	setAttr ".phl[67]" 0;
	setAttr ".phl[68]" 0;
	setAttr ".phl[69]" 0;
	setAttr ".phl[70]" 0;
	setAttr ".phl[71]" 0;
	setAttr ".phl[72]" 0;
	setAttr ".phl[73]" 0;
	setAttr ".phl[74]" 0;
	setAttr ".phl[75]" 0;
	setAttr ".phl[76]" 0;
	setAttr ".phl[77]" 0;
	setAttr ".phl[78]" 0;
	setAttr ".phl[79]" 0;
	setAttr ".phl[80]" 0;
	setAttr ".phl[81]" 0;
	setAttr ".phl[82]" 0;
	setAttr ".phl[83]" 0;
	setAttr ".phl[84]" 0;
	setAttr ".phl[85]" 0;
	setAttr ".phl[86]" 0;
	setAttr ".phl[87]" 0;
	setAttr ".phl[88]" 0;
	setAttr ".phl[89]" 0;
	setAttr ".phl[90]" 0;
	setAttr ".phl[91]" 0;
	setAttr ".phl[92]" 0;
	setAttr ".phl[93]" 0;
	setAttr ".phl[94]" 0;
	setAttr ".phl[95]" 0;
	setAttr ".phl[96]" 0;
	setAttr ".phl[97]" 0;
	setAttr ".phl[98]" 0;
	setAttr ".phl[99]" 0;
	setAttr ".phl[100]" 0;
	setAttr ".phl[101]" 0;
	setAttr ".phl[102]" 0;
	setAttr ".phl[103]" 0;
	setAttr ".phl[104]" 0;
	setAttr ".phl[105]" 0;
	setAttr ".phl[106]" 0;
	setAttr ".phl[107]" 0;
	setAttr ".phl[108]" 0;
	setAttr ".phl[109]" 0;
	setAttr ".phl[110]" 0;
	setAttr ".phl[111]" 0;
	setAttr ".phl[112]" 0;
	setAttr ".phl[113]" 0;
	setAttr ".phl[114]" 0;
	setAttr ".phl[115]" 0;
	setAttr ".phl[116]" 0;
	setAttr ".phl[117]" 0;
	setAttr ".phl[118]" 0;
	setAttr ".phl[119]" 0;
	setAttr ".phl[120]" 0;
	setAttr ".phl[121]" 0;
	setAttr ".phl[122]" 0;
	setAttr ".phl[123]" 0;
	setAttr ".phl[124]" 0;
	setAttr ".phl[125]" 0;
	setAttr ".phl[126]" 0;
	setAttr ".phl[127]" 0;
	setAttr ".phl[128]" 0;
	setAttr ".phl[129]" 0;
	setAttr ".phl[130]" 0;
	setAttr ".phl[131]" 0;
	setAttr ".ed" -type "dataReferenceEdits" 
		"breakingcrate_destRN"
		"breakingcrate_destRN" 0
		"breakingcrate_vmatRN1" 0
		"breakingcrate_destRN" 147
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape1" "|breakingcrate_physics|breakingcrate_physics_grp1" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape2" "|breakingcrate_physics|breakingcrate_physics_grp2" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape3" "|breakingcrate_physics|breakingcrate_physics_grp3" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape4" "|breakingcrate_physics|breakingcrate_physics_grp4" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape5" "|breakingcrate_physics|breakingcrate_physics_grp5" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape6" "|breakingcrate_physics|breakingcrate_physics_grp6" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape7" "|breakingcrate_physics|breakingcrate_physics_grp7" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape8" "|breakingcrate_physics|breakingcrate_physics_grp8" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape9" "|breakingcrate_physics|breakingcrate_physics_grp9" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape10" "|breakingcrate_physics|breakingcrate_physics_grp10" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape11" "|breakingcrate_physics|breakingcrate_physics_grp11" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape12" "|breakingcrate_physics|breakingcrate_physics_grp12" 
		"-s -r "
		0 "|breakingcrate_destRNfosterParent1|bulletRigidBodyShape13" "|breakingcrate_physics|breakingcrate_physics_grp13" 
		"-s -r "
		2 "|breakingcrate_physics" "visibility" " 1"
		2 "GEO" "visibility" " 0"
		2 "JOINTS" "visibility" " 0"
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint1.message" 
		"breakingcrate_destRN.placeHolderList[1]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint2.message" 
		"breakingcrate_destRN.placeHolderList[2]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint3.message" 
		"breakingcrate_destRN.placeHolderList[3]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint4.message" 
		"breakingcrate_destRN.placeHolderList[4]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint5.message" 
		"breakingcrate_destRN.placeHolderList[5]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint6.message" 
		"breakingcrate_destRN.placeHolderList[6]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint7.message" 
		"breakingcrate_destRN.placeHolderList[7]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint8.message" 
		"breakingcrate_destRN.placeHolderList[8]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint9.message" 
		"breakingcrate_destRN.placeHolderList[9]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint10.message" 
		"breakingcrate_destRN.placeHolderList[10]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint11.message" 
		"breakingcrate_destRN.placeHolderList[11]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint12.message" 
		"breakingcrate_destRN.placeHolderList[12]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_joints|breakingcrate_joint13.message" 
		"breakingcrate_destRN.placeHolderList[13]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1.translateX" 
		"breakingcrate_destRN.placeHolderList[14]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1.translateY" 
		"breakingcrate_destRN.placeHolderList[15]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1.translateZ" 
		"breakingcrate_destRN.placeHolderList[16]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[17]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1.rotateX" 
		"breakingcrate_destRN.placeHolderList[18]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1.rotateY" 
		"breakingcrate_destRN.placeHolderList[19]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1.rotateZ" 
		"breakingcrate_destRN.placeHolderList[20]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[21]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[22]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp1|breakingcrate_physics_grp1Shape.outMesh" 
		"breakingcrate_destRN.placeHolderList[23]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp2.translateX" 
		"breakingcrate_destRN.placeHolderList[24]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp2.translateY" 
		"breakingcrate_destRN.placeHolderList[25]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp2.translateZ" 
		"breakingcrate_destRN.placeHolderList[26]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp2.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[27]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp2.rotateX" 
		"breakingcrate_destRN.placeHolderList[28]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp2.rotateY" 
		"breakingcrate_destRN.placeHolderList[29]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp2.rotateZ" 
		"breakingcrate_destRN.placeHolderList[30]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp2.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[31]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp2.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[32]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp3.translateX" 
		"breakingcrate_destRN.placeHolderList[33]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp3.translateY" 
		"breakingcrate_destRN.placeHolderList[34]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp3.translateZ" 
		"breakingcrate_destRN.placeHolderList[35]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp3.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[36]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp3.rotateX" 
		"breakingcrate_destRN.placeHolderList[37]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp3.rotateY" 
		"breakingcrate_destRN.placeHolderList[38]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp3.rotateZ" 
		"breakingcrate_destRN.placeHolderList[39]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp3.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[40]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp3.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[41]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp4.translateX" 
		"breakingcrate_destRN.placeHolderList[42]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp4.translateY" 
		"breakingcrate_destRN.placeHolderList[43]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp4.translateZ" 
		"breakingcrate_destRN.placeHolderList[44]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp4.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[45]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp4.rotateX" 
		"breakingcrate_destRN.placeHolderList[46]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp4.rotateY" 
		"breakingcrate_destRN.placeHolderList[47]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp4.rotateZ" 
		"breakingcrate_destRN.placeHolderList[48]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp4.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[49]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp4.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[50]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp5.translateX" 
		"breakingcrate_destRN.placeHolderList[51]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp5.translateY" 
		"breakingcrate_destRN.placeHolderList[52]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp5.translateZ" 
		"breakingcrate_destRN.placeHolderList[53]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp5.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[54]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp5.rotateX" 
		"breakingcrate_destRN.placeHolderList[55]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp5.rotateY" 
		"breakingcrate_destRN.placeHolderList[56]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp5.rotateZ" 
		"breakingcrate_destRN.placeHolderList[57]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp5.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[58]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp5.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[59]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp6.translateX" 
		"breakingcrate_destRN.placeHolderList[60]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp6.translateY" 
		"breakingcrate_destRN.placeHolderList[61]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp6.translateZ" 
		"breakingcrate_destRN.placeHolderList[62]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp6.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[63]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp6.rotateX" 
		"breakingcrate_destRN.placeHolderList[64]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp6.rotateY" 
		"breakingcrate_destRN.placeHolderList[65]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp6.rotateZ" 
		"breakingcrate_destRN.placeHolderList[66]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp6.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[67]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp6.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[68]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp7.translateX" 
		"breakingcrate_destRN.placeHolderList[69]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp7.translateY" 
		"breakingcrate_destRN.placeHolderList[70]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp7.translateZ" 
		"breakingcrate_destRN.placeHolderList[71]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp7.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[72]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp7.rotateX" 
		"breakingcrate_destRN.placeHolderList[73]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp7.rotateY" 
		"breakingcrate_destRN.placeHolderList[74]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp7.rotateZ" 
		"breakingcrate_destRN.placeHolderList[75]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp7.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[76]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp7.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[77]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp8.translateX" 
		"breakingcrate_destRN.placeHolderList[78]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp8.translateY" 
		"breakingcrate_destRN.placeHolderList[79]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp8.translateZ" 
		"breakingcrate_destRN.placeHolderList[80]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp8.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[81]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp8.rotateX" 
		"breakingcrate_destRN.placeHolderList[82]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp8.rotateY" 
		"breakingcrate_destRN.placeHolderList[83]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp8.rotateZ" 
		"breakingcrate_destRN.placeHolderList[84]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp8.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[85]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp8.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[86]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp9.translateX" 
		"breakingcrate_destRN.placeHolderList[87]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp9.translateY" 
		"breakingcrate_destRN.placeHolderList[88]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp9.translateZ" 
		"breakingcrate_destRN.placeHolderList[89]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp9.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[90]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp9.rotateX" 
		"breakingcrate_destRN.placeHolderList[91]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp9.rotateY" 
		"breakingcrate_destRN.placeHolderList[92]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp9.rotateZ" 
		"breakingcrate_destRN.placeHolderList[93]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp9.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[94]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp9.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[95]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp10.translateX" 
		"breakingcrate_destRN.placeHolderList[96]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp10.translateY" 
		"breakingcrate_destRN.placeHolderList[97]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp10.translateZ" 
		"breakingcrate_destRN.placeHolderList[98]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp10.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[99]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp10.rotateX" 
		"breakingcrate_destRN.placeHolderList[100]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp10.rotateY" 
		"breakingcrate_destRN.placeHolderList[101]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp10.rotateZ" 
		"breakingcrate_destRN.placeHolderList[102]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp10.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[103]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp10.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[104]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp11.translateX" 
		"breakingcrate_destRN.placeHolderList[105]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp11.translateY" 
		"breakingcrate_destRN.placeHolderList[106]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp11.translateZ" 
		"breakingcrate_destRN.placeHolderList[107]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp11.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[108]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp11.rotateX" 
		"breakingcrate_destRN.placeHolderList[109]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp11.rotateY" 
		"breakingcrate_destRN.placeHolderList[110]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp11.rotateZ" 
		"breakingcrate_destRN.placeHolderList[111]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp11.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[112]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp11.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[113]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp12.translateX" 
		"breakingcrate_destRN.placeHolderList[114]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp12.translateY" 
		"breakingcrate_destRN.placeHolderList[115]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp12.translateZ" 
		"breakingcrate_destRN.placeHolderList[116]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp12.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[117]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp12.rotateX" 
		"breakingcrate_destRN.placeHolderList[118]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp12.rotateY" 
		"breakingcrate_destRN.placeHolderList[119]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp12.rotateZ" 
		"breakingcrate_destRN.placeHolderList[120]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp12.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[121]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp12.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[122]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp13.translateX" 
		"breakingcrate_destRN.placeHolderList[123]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp13.translateY" 
		"breakingcrate_destRN.placeHolderList[124]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp13.translateZ" 
		"breakingcrate_destRN.placeHolderList[125]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp13.rotatePivot" 
		"breakingcrate_destRN.placeHolderList[126]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp13.rotateX" 
		"breakingcrate_destRN.placeHolderList[127]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp13.rotateY" 
		"breakingcrate_destRN.placeHolderList[128]" ""
		5 4 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp13.rotateZ" 
		"breakingcrate_destRN.placeHolderList[129]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp13.worldMatrix" 
		"breakingcrate_destRN.placeHolderList[130]" ""
		5 3 "breakingcrate_destRN" "|breakingcrate_physics|breakingcrate_physics_grp13.parentInverseMatrix" 
		"breakingcrate_destRN.placeHolderList[131]" ""
		"breakingcrate_vmatRN1" 1
		2 "breakingcrate_vmat1:dota2_hero_shaderfx" "shaderparams" " -type \"string\" \"fresnelWarpColor~278~fresnelWarpRim~278~fresnelWarpSpec~278~cubeMap~278~color~278~normal~278~specularMask~278~specularColor~319~specularExponent~317~specularScale~317~rimMask~278~rimLightColor~319~rimLightScale~317~selfIllumMask~278~translucency~278~metalnessMask~278~cubeMapScalar~317~\"";
	setAttr ".ptag" -type "string" "";
lockNode -l 1 ;
createNode renderLayer -s -n "globalRender";
	rename -uid "C06E7383-4275-D589-DAC0-1180FB95CE52";
createNode pairBlend -n "translateRotate";
	rename -uid "6EDD59DE-4C7C-6B2C-146E-E1918E1E1078";
createNode pairBlend -n "translateRotate1";
	rename -uid "A2522A08-46AF-1B80-445D-728A9F85C31A";
createNode pairBlend -n "translateRotate2";
	rename -uid "532ACBF3-4C72-D03B-5927-22921517D090";
createNode pairBlend -n "translateRotate3";
	rename -uid "72E5445C-4284-42BA-23FD-AF975422C287";
createNode pairBlend -n "translateRotate4";
	rename -uid "DF5C69E9-4B9C-0E1A-2735-90972C03CA21";
createNode pairBlend -n "translateRotate5";
	rename -uid "E8EAE13D-4067-A196-6D1C-2E9804168A24";
createNode pairBlend -n "translateRotate6";
	rename -uid "52C40756-4D83-FA25-4948-C7950D569A13";
createNode pairBlend -n "translateRotate7";
	rename -uid "23EF78FB-4C0B-3134-F815-60B5436BF510";
createNode pairBlend -n "translateRotate8";
	rename -uid "046AD074-4A39-00A5-E2D1-7192FEC8C1B9";
createNode pairBlend -n "translateRotate9";
	rename -uid "D4A8A8F4-4A25-D4B3-7E4A-8389A10F75E1";
createNode pairBlend -n "translateRotate10";
	rename -uid "23CA51B4-487C-3EC4-5F33-758804E44CD4";
createNode pairBlend -n "translateRotate11";
	rename -uid "BA0BB446-4289-DBDF-2D8F-6F867C9FE445";
createNode pairBlend -n "translateRotate12";
	rename -uid "AFA3A24D-4106-756D-FECE-3EA0A47E4702";
createNode script -n "uiConfigurationScriptNode1";
	rename -uid "AA4CE460-4403-BBC8-7E21-A887E8E12331";
	setAttr ".b" -type "string" (
		"// Maya Mel UI Configuration File.\n//\n//  This script is machine generated.  Edit at your own risk.\n//\n//\n\nglobal string $gMainPane;\nif (`paneLayout -exists $gMainPane`) {\n\n\tglobal int $gUseScenePanelConfig;\n\tint    $useSceneConfig = $gUseScenePanelConfig;\n\tint    $menusOkayInPanels = `optionVar -q allowMenusInPanels`;\tint    $nVisPanes = `paneLayout -q -nvp $gMainPane`;\n\tint    $nPanes = 0;\n\tstring $editorName;\n\tstring $panelName;\n\tstring $itemFilterName;\n\tstring $panelConfig;\n\n\t//\n\t//  get current state of the UI\n\t//\n\tsceneUIReplacement -update $gMainPane;\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Top View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Top View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"top\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n"
		+ "                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -holdOuts 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 32768\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -depthOfFieldPreview 1\n                -maxConstantTransparency 1\n"
		+ "                -rendererName \"vp2Renderer\" \n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 256 256 \n                -bumpResolution 512 512 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n"
		+ "                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 1\n                -height 1\n                -sceneRenderFilter 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n"
		+ "                -pluginObjects \"vPlanarDisplay\" 1 \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                -pluginObjects \"vRigWidget\" 1 \n                -pluginObjects \"vChainDisplay\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Top View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"top\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n"
		+ "            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n"
		+ "            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 1\n            -shadows 0\n"
		+ "            -captureSequenceNumber -1\n            -width 1\n            -height 1\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"vPlanarDisplay\" 1 \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            -pluginObjects \"vRigWidget\" 1 \n            -pluginObjects \"vChainDisplay\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Side View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Side View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"side\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -ignorePanZoom 0\n"
		+ "                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -holdOuts 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 32768\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -depthOfFieldPreview 1\n                -maxConstantTransparency 1\n                -rendererName \"vp2Renderer\" \n"
		+ "                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 256 256 \n                -bumpResolution 512 512 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n"
		+ "                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 1\n                -height 1\n                -sceneRenderFilter 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n                -pluginObjects \"vPlanarDisplay\" 1 \n"
		+ "                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                -pluginObjects \"vRigWidget\" 1 \n                -pluginObjects \"vChainDisplay\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Side View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"side\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n"
		+ "            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n"
		+ "            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 1\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 1\n            -height 1\n"
		+ "            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"vPlanarDisplay\" 1 \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            -pluginObjects \"vRigWidget\" 1 \n            -pluginObjects \"vChainDisplay\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Front View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Front View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"front\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n"
		+ "                -holdOuts 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 32768\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -depthOfFieldPreview 1\n                -maxConstantTransparency 1\n                -rendererName \"vp2Renderer\" \n                -objectFilterShowInHUD 1\n                -isFiltered 0\n"
		+ "                -colorResolution 256 256 \n                -bumpResolution 512 512 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n"
		+ "                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 1\n                -height 1\n                -sceneRenderFilter 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n                -pluginObjects \"vPlanarDisplay\" 1 \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n"
		+ "                -pluginObjects \"vRigWidget\" 1 \n                -pluginObjects \"vChainDisplay\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Front View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"front\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n"
		+ "            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n"
		+ "            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 1\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 1\n            -height 1\n            -sceneRenderFilter 0\n"
		+ "            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"vPlanarDisplay\" 1 \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            -pluginObjects \"vRigWidget\" 1 \n            -pluginObjects \"vChainDisplay\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Persp View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"wireframe\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -holdOuts 1\n                -selectionHiliteDisplay 1\n"
		+ "                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 32768\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -depthOfFieldPreview 1\n                -maxConstantTransparency 1\n                -rendererName \"vp2Renderer\" \n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 256 256 \n                -bumpResolution 512 512 \n"
		+ "                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n"
		+ "                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 1287\n                -height 1292\n                -sceneRenderFilter 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n                -pluginObjects \"vPlanarDisplay\" 1 \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                -pluginObjects \"vRigWidget\" 1 \n                -pluginObjects \"vChainDisplay\" 1 \n"
		+ "                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"persp\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"wireframe\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n"
		+ "            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n"
		+ "            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 1\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 1287\n            -height 1292\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n"
		+ "        modelEditor -e \n            -pluginObjects \"vPlanarDisplay\" 1 \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            -pluginObjects \"vRigWidget\" 1 \n            -pluginObjects \"vChainDisplay\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"outlinerPanel\" (localizedPanelLabel(\"Outliner\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `outlinerPanel -unParent -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            outlinerEditor -e \n                -docTag \"isolOutln_fromSeln\" \n                -showShapes 0\n                -showAssignedMaterials 0\n                -showReferenceNodes 1\n                -showReferenceMembers 1\n                -showAttributes 0\n                -showConnected 0\n                -showAnimCurvesOnly 0\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n"
		+ "                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 1\n                -showAssets 1\n                -showContainedOnly 1\n                -showPublishedAsConnected 0\n                -showContainerContents 1\n                -ignoreDagHierarchy 0\n                -expandConnections 0\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 0\n                -highlightActive 1\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"defaultSetFilter\" \n                -showSetMembers 1\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -isSet 0\n                -isSetMember 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n"
		+ "                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 0\n                -ignoreHiddenAttribute 1\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                -renderFilterIndex 0\n                -selectionOrder \"chronological\" \n                -expandAttribute 0\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\toutlinerPanel -edit -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        outlinerEditor -e \n            -docTag \"isolOutln_fromSeln\" \n"
		+ "            -showShapes 0\n            -showAssignedMaterials 0\n            -showReferenceNodes 1\n            -showReferenceMembers 1\n            -showAttributes 0\n            -showConnected 0\n            -showAnimCurvesOnly 0\n            -showMuteInfo 0\n            -organizeByLayer 1\n            -showAnimLayerWeight 1\n            -autoExpandLayers 1\n            -autoExpand 0\n            -showDagOnly 1\n            -showAssets 1\n            -showContainedOnly 1\n            -showPublishedAsConnected 0\n            -showContainerContents 1\n            -ignoreDagHierarchy 0\n            -expandConnections 0\n            -showUpstreamCurves 1\n            -showUnitlessCurves 1\n            -showCompounds 1\n            -showLeafs 1\n            -showNumericAttrsOnly 0\n            -highlightActive 1\n            -autoSelectNewObjects 0\n            -doNotSelectNewObjects 0\n            -dropIsParent 1\n            -transmitFilters 0\n            -setFilter \"defaultSetFilter\" \n            -showSetMembers 1\n            -allowMultiSelection 1\n"
		+ "            -alwaysToggleSelect 0\n            -directSelect 0\n            -isSet 0\n            -isSetMember 0\n            -displayMode \"DAG\" \n            -expandObjects 0\n            -setsIgnoreFilters 1\n            -containersIgnoreFilters 0\n            -editAttrName 0\n            -showAttrValues 0\n            -highlightSecondary 0\n            -showUVAttrsOnly 0\n            -showTextureNodesOnly 0\n            -attrAlphaOrder \"default\" \n            -animLayerFilterOptions \"allAffecting\" \n            -sortOrder \"none\" \n            -longNames 0\n            -niceNames 1\n            -showNamespace 1\n            -showPinIcons 0\n            -mapMotionTrails 0\n            -ignoreHiddenAttribute 1\n            -ignoreOutlinerColor 0\n            -renderFilterVisible 0\n            -renderFilterIndex 0\n            -selectionOrder \"chronological\" \n            -expandAttribute 0\n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"graphEditor\" (localizedPanelLabel(\"Graph Editor\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"graphEditor\" -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n"
		+ "                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 1\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 1\n                -mapMotionTrails 1\n"
		+ "                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 1\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -showResults \"off\" \n                -showBufferCurves \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1\n                -resultScreenSamples 0\n                -resultUpdate \"delayed\" \n                -showUpstreamCurves 1\n                -showCurveNames 0\n                -showActiveCurveNames 0\n                -stackedCurves 0\n                -stackedCurvesMin -1\n                -stackedCurvesMax 1\n                -stackedCurvesSpace 0.2\n                -displayNormalized 0\n"
		+ "                -preSelectionHighlight 0\n                -constrainDrag 0\n                -classicMode 1\n                -outliner \"graphEditor1OutlineEd\" \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n"
		+ "                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 1\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n"
		+ "                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 1\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 1\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -showResults \"off\" \n                -showBufferCurves \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1\n                -resultScreenSamples 0\n                -resultUpdate \"delayed\" \n                -showUpstreamCurves 1\n                -showCurveNames 0\n                -showActiveCurveNames 0\n"
		+ "                -stackedCurves 0\n                -stackedCurvesMin -1\n                -stackedCurvesMax 1\n                -stackedCurvesSpace 0.2\n                -displayNormalized 0\n                -preSelectionHighlight 0\n                -constrainDrag 0\n                -classicMode 1\n                -outliner \"graphEditor1OutlineEd\" \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dopeSheetPanel\" (localizedPanelLabel(\"Dope Sheet\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dopeSheetPanel\" -l (localizedPanelLabel(\"Dope Sheet\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n"
		+ "                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 0\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 1\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n"
		+ "                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"DopeSheetEd\");\n            dopeSheetEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"integer\" \n"
		+ "                -snapValue \"none\" \n                -outliner \"dopeSheetPanel1OutlineEd\" \n                -showSummary 1\n                -showScene 0\n                -hierarchyBelow 0\n                -showTicks 1\n                -selectionWindow 0 0 0 0 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Dope Sheet\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n"
		+ "                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 0\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 1\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n"
		+ "                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"DopeSheetEd\");\n            dopeSheetEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -outliner \"dopeSheetPanel1OutlineEd\" \n                -showSummary 1\n                -showScene 0\n                -hierarchyBelow 0\n                -showTicks 1\n                -selectionWindow 0 0 0 0 \n                $editorName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"clipEditorPanel\" (localizedPanelLabel(\"Trax Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"clipEditorPanel\" -l (localizedPanelLabel(\"Trax Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = clipEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -initialized 0\n                -manageSequencer 0 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Trax Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = clipEditorNameFromPanel($panelName);\n"
		+ "            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -initialized 0\n                -manageSequencer 0 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"sequenceEditorPanel\" (localizedPanelLabel(\"Camera Sequencer\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"sequenceEditorPanel\" -l (localizedPanelLabel(\"Camera Sequencer\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = sequenceEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n"
		+ "                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -initialized 0\n                -manageSequencer 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Camera Sequencer\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = sequenceEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -initialized 0\n                -manageSequencer 1 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"hyperGraphPanel\" (localizedPanelLabel(\"Hypergraph Hierarchy\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"hyperGraphPanel\" -l (localizedPanelLabel(\"Hypergraph Hierarchy\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"HyperGraphEd\");\n            hyperGraph -e \n                -graphLayoutStyle \"hierarchicalLayout\" \n                -orientation \"horiz\" \n                -mergeConnections 0\n                -zoom 1\n                -animateTransition 0\n                -showRelationships 1\n                -showShapes 0\n                -showDeformers 0\n                -showExpressions 0\n                -showConstraints 0\n                -showConnectionFromSelected 0\n                -showConnectionToSelected 0\n                -showConstraintLabels 0\n                -showUnderworld 0\n                -showInvisible 0\n                -transitionFrames 1\n                -opaqueContainers 0\n                -freeform 0\n                -imagePosition 0 0 \n                -imageScale 1\n                -imageEnabled 0\n                -graphType \"DAG\" \n"
		+ "                -heatMapDisplay 0\n                -updateSelection 1\n                -updateNodeAdded 1\n                -useDrawOverrideColor 0\n                -limitGraphTraversal -1\n                -range 0 0 \n                -iconSize \"smallIcons\" \n                -showCachedConnections 0\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Hypergraph Hierarchy\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"HyperGraphEd\");\n            hyperGraph -e \n                -graphLayoutStyle \"hierarchicalLayout\" \n                -orientation \"horiz\" \n                -mergeConnections 0\n                -zoom 1\n                -animateTransition 0\n                -showRelationships 1\n                -showShapes 0\n                -showDeformers 0\n                -showExpressions 0\n                -showConstraints 0\n                -showConnectionFromSelected 0\n                -showConnectionToSelected 0\n                -showConstraintLabels 0\n"
		+ "                -showUnderworld 0\n                -showInvisible 0\n                -transitionFrames 1\n                -opaqueContainers 0\n                -freeform 0\n                -imagePosition 0 0 \n                -imageScale 1\n                -imageEnabled 0\n                -graphType \"DAG\" \n                -heatMapDisplay 0\n                -updateSelection 1\n                -updateNodeAdded 1\n                -useDrawOverrideColor 0\n                -limitGraphTraversal -1\n                -range 0 0 \n                -iconSize \"smallIcons\" \n                -showCachedConnections 0\n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"visorPanel\" (localizedPanelLabel(\"Visor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"visorPanel\" -l (localizedPanelLabel(\"Visor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Visor\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"createNodePanel\" (localizedPanelLabel(\"Create Node\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"createNodePanel\" -l (localizedPanelLabel(\"Create Node\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Create Node\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"polyTexturePlacementPanel\" (localizedPanelLabel(\"UV Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"polyTexturePlacementPanel\" -l (localizedPanelLabel(\"UV Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"UV Editor\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"renderWindowPanel\" (localizedPanelLabel(\"Render View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"renderWindowPanel\" -l (localizedPanelLabel(\"Render View\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Render View\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"shapePanel\" (localizedPanelLabel(\"Shape Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\tshapePanel -unParent -l (localizedPanelLabel(\"Shape Editor\")) -mbv $menusOkayInPanels ;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tshapePanel -edit -l (localizedPanelLabel(\"Shape Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n"
		+ "\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"posePanel\" (localizedPanelLabel(\"Pose Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\tposePanel -unParent -l (localizedPanelLabel(\"Pose Editor\")) -mbv $menusOkayInPanels ;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tposePanel -edit -l (localizedPanelLabel(\"Pose Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dynRelEdPanel\" (localizedPanelLabel(\"Dynamic Relationships\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dynRelEdPanel\" -l (localizedPanelLabel(\"Dynamic Relationships\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Dynamic Relationships\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"relationshipPanel\" (localizedPanelLabel(\"Relationship Editor\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"relationshipPanel\" -l (localizedPanelLabel(\"Relationship Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Relationship Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"referenceEditorPanel\" (localizedPanelLabel(\"Reference Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"referenceEditorPanel\" -l (localizedPanelLabel(\"Reference Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Reference Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"componentEditorPanel\" (localizedPanelLabel(\"Component Editor\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"componentEditorPanel\" -l (localizedPanelLabel(\"Component Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Component Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dynPaintScriptedPanelType\" (localizedPanelLabel(\"Paint Effects\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dynPaintScriptedPanelType\" -l (localizedPanelLabel(\"Paint Effects\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Paint Effects\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"scriptEditorPanel\" (localizedPanelLabel(\"Script Editor\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"scriptEditorPanel\" -l (localizedPanelLabel(\"Script Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Script Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"profilerPanel\" (localizedPanelLabel(\"Profiler Tool\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"profilerPanel\" -l (localizedPanelLabel(\"Profiler Tool\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Profiler Tool\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"contentBrowserPanel\" (localizedPanelLabel(\"Content Browser\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"contentBrowserPanel\" -l (localizedPanelLabel(\"Content Browser\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Content Browser\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"Stereo\" (localizedPanelLabel(\"Stereo\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"Stereo\" -l (localizedPanelLabel(\"Stereo\")) -mbv $menusOkayInPanels `;\nstring $editorName = ($panelName+\"Editor\");\n            stereoCameraView -e \n                -camera \"persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n"
		+ "                -headsUpDisplay 1\n                -holdOuts 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 32768\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -depthOfFieldPreview 1\n                -maxConstantTransparency 1\n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 4 4 \n"
		+ "                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n"
		+ "                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 0\n                -height 0\n                -sceneRenderFilter 0\n                -displayMode \"centerEye\" \n                -viewColor 0 0 0 1 \n                -useCustomBackground 1\n                $editorName;\n            stereoCameraView -e -viewSelected 0 $editorName;\n            stereoCameraView -e \n                -pluginObjects \"vPlanarDisplay\" 1 \n"
		+ "                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                -pluginObjects \"vRigWidget\" 1 \n                -pluginObjects \"vChainDisplay\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Stereo\")) -mbv $menusOkayInPanels  $panelName;\nstring $editorName = ($panelName+\"Editor\");\n            stereoCameraView -e \n                -camera \"persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -holdOuts 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n"
		+ "                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 32768\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -depthOfFieldPreview 1\n                -maxConstantTransparency 1\n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 4 4 \n                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n"
		+ "                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n"
		+ "                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 0\n                -height 0\n                -sceneRenderFilter 0\n                -displayMode \"centerEye\" \n                -viewColor 0 0 0 1 \n                -useCustomBackground 1\n                $editorName;\n            stereoCameraView -e -viewSelected 0 $editorName;\n            stereoCameraView -e \n                -pluginObjects \"vPlanarDisplay\" 1 \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                -pluginObjects \"vRigWidget\" 1 \n                -pluginObjects \"vChainDisplay\" 1 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"hyperShadePanel\" (localizedPanelLabel(\"Hypershade\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"hyperShadePanel\" -l (localizedPanelLabel(\"Hypershade\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Hypershade\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"nodeEditorPanel\" (localizedPanelLabel(\"Node Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"nodeEditorPanel\" -l (localizedPanelLabel(\"Node Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"NodeEditorEd\");\n            nodeEditor -e \n                -allAttributes 0\n                -allNodes 0\n                -autoSizeNodes 1\n                -consistentNameSize 1\n                -createNodeCommand \"nodeEdCreateNodeCommand\" \n                -defaultPinnedState 0\n                -additiveGraphingMode 0\n"
		+ "                -settingsChangedCallback \"nodeEdSyncControls\" \n                -traversalDepthLimit -1\n                -keyPressCommand \"nodeEdKeyPressCommand\" \n                -nodeTitleMode \"name\" \n                -gridSnap 0\n                -gridVisibility 1\n                -popupMenuScript \"nodeEdBuildPanelMenus\" \n                -showNamespace 1\n                -showShapes 1\n                -showSGShapes 0\n                -showTransforms 1\n                -useAssets 1\n                -syncedSelection 1\n                -extendToShapes 1\n                -activeTab -1\n                -editorMode \"default\" \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Node Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"NodeEditorEd\");\n            nodeEditor -e \n                -allAttributes 0\n                -allNodes 0\n                -autoSizeNodes 1\n                -consistentNameSize 1\n                -createNodeCommand \"nodeEdCreateNodeCommand\" \n"
		+ "                -defaultPinnedState 0\n                -additiveGraphingMode 0\n                -settingsChangedCallback \"nodeEdSyncControls\" \n                -traversalDepthLimit -1\n                -keyPressCommand \"nodeEdKeyPressCommand\" \n                -nodeTitleMode \"name\" \n                -gridSnap 0\n                -gridVisibility 1\n                -popupMenuScript \"nodeEdBuildPanelMenus\" \n                -showNamespace 1\n                -showShapes 1\n                -showSGShapes 0\n                -showTransforms 1\n                -useAssets 1\n                -syncedSelection 1\n                -extendToShapes 1\n                -activeTab -1\n                -editorMode \"default\" \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\tif ($useSceneConfig) {\n        string $configName = `getPanel -cwl (localizedPanelLabel(\"Current Layout\"))`;\n        if (\"\" != $configName) {\n\t\t\tpanelConfiguration -edit -label (localizedPanelLabel(\"Current Layout\")) \n\t\t\t\t-defaultImage \"vacantCell.xP:/\"\n"
		+ "\t\t\t\t-image \"\"\n\t\t\t\t-sc false\n\t\t\t\t-configString \"global string $gMainPane; paneLayout -e -cn \\\"vertical2\\\" -ps 1 23 100 -ps 2 77 100 $gMainPane;\"\n\t\t\t\t-removeAllPanels\n\t\t\t\t-ap false\n\t\t\t\t\t(localizedPanelLabel(\"Outliner\")) \n\t\t\t\t\t\"outlinerPanel\"\n\t\t\t\t\t\"$panelName = `outlinerPanel -unParent -l (localizedPanelLabel(\\\"Outliner\\\")) -mbv $menusOkayInPanels `;\\n$editorName = $panelName;\\noutlinerEditor -e \\n    -docTag \\\"isolOutln_fromSeln\\\" \\n    -showShapes 0\\n    -showAssignedMaterials 0\\n    -showReferenceNodes 1\\n    -showReferenceMembers 1\\n    -showAttributes 0\\n    -showConnected 0\\n    -showAnimCurvesOnly 0\\n    -showMuteInfo 0\\n    -organizeByLayer 1\\n    -showAnimLayerWeight 1\\n    -autoExpandLayers 1\\n    -autoExpand 0\\n    -showDagOnly 1\\n    -showAssets 1\\n    -showContainedOnly 1\\n    -showPublishedAsConnected 0\\n    -showContainerContents 1\\n    -ignoreDagHierarchy 0\\n    -expandConnections 0\\n    -showUpstreamCurves 1\\n    -showUnitlessCurves 1\\n    -showCompounds 1\\n    -showLeafs 1\\n    -showNumericAttrsOnly 0\\n    -highlightActive 1\\n    -autoSelectNewObjects 0\\n    -doNotSelectNewObjects 0\\n    -dropIsParent 1\\n    -transmitFilters 0\\n    -setFilter \\\"defaultSetFilter\\\" \\n    -showSetMembers 1\\n    -allowMultiSelection 1\\n    -alwaysToggleSelect 0\\n    -directSelect 0\\n    -isSet 0\\n    -isSetMember 0\\n    -displayMode \\\"DAG\\\" \\n    -expandObjects 0\\n    -setsIgnoreFilters 1\\n    -containersIgnoreFilters 0\\n    -editAttrName 0\\n    -showAttrValues 0\\n    -highlightSecondary 0\\n    -showUVAttrsOnly 0\\n    -showTextureNodesOnly 0\\n    -attrAlphaOrder \\\"default\\\" \\n    -animLayerFilterOptions \\\"allAffecting\\\" \\n    -sortOrder \\\"none\\\" \\n    -longNames 0\\n    -niceNames 1\\n    -showNamespace 1\\n    -showPinIcons 0\\n    -mapMotionTrails 0\\n    -ignoreHiddenAttribute 1\\n    -ignoreOutlinerColor 0\\n    -renderFilterVisible 0\\n    -renderFilterIndex 0\\n    -selectionOrder \\\"chronological\\\" \\n    -expandAttribute 0\\n    $editorName\"\n"
		+ "\t\t\t\t\t\"outlinerPanel -edit -l (localizedPanelLabel(\\\"Outliner\\\")) -mbv $menusOkayInPanels  $panelName;\\n$editorName = $panelName;\\noutlinerEditor -e \\n    -docTag \\\"isolOutln_fromSeln\\\" \\n    -showShapes 0\\n    -showAssignedMaterials 0\\n    -showReferenceNodes 1\\n    -showReferenceMembers 1\\n    -showAttributes 0\\n    -showConnected 0\\n    -showAnimCurvesOnly 0\\n    -showMuteInfo 0\\n    -organizeByLayer 1\\n    -showAnimLayerWeight 1\\n    -autoExpandLayers 1\\n    -autoExpand 0\\n    -showDagOnly 1\\n    -showAssets 1\\n    -showContainedOnly 1\\n    -showPublishedAsConnected 0\\n    -showContainerContents 1\\n    -ignoreDagHierarchy 0\\n    -expandConnections 0\\n    -showUpstreamCurves 1\\n    -showUnitlessCurves 1\\n    -showCompounds 1\\n    -showLeafs 1\\n    -showNumericAttrsOnly 0\\n    -highlightActive 1\\n    -autoSelectNewObjects 0\\n    -doNotSelectNewObjects 0\\n    -dropIsParent 1\\n    -transmitFilters 0\\n    -setFilter \\\"defaultSetFilter\\\" \\n    -showSetMembers 1\\n    -allowMultiSelection 1\\n    -alwaysToggleSelect 0\\n    -directSelect 0\\n    -isSet 0\\n    -isSetMember 0\\n    -displayMode \\\"DAG\\\" \\n    -expandObjects 0\\n    -setsIgnoreFilters 1\\n    -containersIgnoreFilters 0\\n    -editAttrName 0\\n    -showAttrValues 0\\n    -highlightSecondary 0\\n    -showUVAttrsOnly 0\\n    -showTextureNodesOnly 0\\n    -attrAlphaOrder \\\"default\\\" \\n    -animLayerFilterOptions \\\"allAffecting\\\" \\n    -sortOrder \\\"none\\\" \\n    -longNames 0\\n    -niceNames 1\\n    -showNamespace 1\\n    -showPinIcons 0\\n    -mapMotionTrails 0\\n    -ignoreHiddenAttribute 1\\n    -ignoreOutlinerColor 0\\n    -renderFilterVisible 0\\n    -renderFilterIndex 0\\n    -selectionOrder \\\"chronological\\\" \\n    -expandAttribute 0\\n    $editorName\"\n"
		+ "\t\t\t\t-ap false\n\t\t\t\t\t(localizedPanelLabel(\"Persp View\")) \n\t\t\t\t\t\"modelPanel\"\n"
		+ "\t\t\t\t\t\"$panelName = `modelPanel -unParent -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels `;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -cam `findStartUpCamera persp` \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"wireframe\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 0\\n    -headsUpDisplay 1\\n    -holdOuts 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 0\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 32768\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -depthOfFieldPreview 1\\n    -maxConstantTransparency 1\\n    -rendererName \\\"vp2Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 1\\n    -hulls 1\\n    -grid 1\\n    -imagePlane 1\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -particleInstancers 1\\n    -fluids 1\\n    -hairSystems 1\\n    -follicles 1\\n    -nCloths 1\\n    -nParticles 1\\n    -nRigids 1\\n    -dynamicConstraints 1\\n    -locators 1\\n    -manipulators 1\\n    -pluginShapes 1\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -motionTrails 1\\n    -clipGhosts 1\\n    -greasePencils 1\\n    -shadows 0\\n    -captureSequenceNumber -1\\n    -width 1287\\n    -height 1292\\n    -sceneRenderFilter 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"vPlanarDisplay\\\" 1 \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    -pluginObjects \\\"vRigWidget\\\" 1 \\n    -pluginObjects \\\"vChainDisplay\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t\t\"modelPanel -edit -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels  $panelName;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -cam `findStartUpCamera persp` \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"wireframe\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 0\\n    -headsUpDisplay 1\\n    -holdOuts 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 0\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 32768\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -depthOfFieldPreview 1\\n    -maxConstantTransparency 1\\n    -rendererName \\\"vp2Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 1\\n    -hulls 1\\n    -grid 1\\n    -imagePlane 1\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -particleInstancers 1\\n    -fluids 1\\n    -hairSystems 1\\n    -follicles 1\\n    -nCloths 1\\n    -nParticles 1\\n    -nRigids 1\\n    -dynamicConstraints 1\\n    -locators 1\\n    -manipulators 1\\n    -pluginShapes 1\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -motionTrails 1\\n    -clipGhosts 1\\n    -greasePencils 1\\n    -shadows 0\\n    -captureSequenceNumber -1\\n    -width 1287\\n    -height 1292\\n    -sceneRenderFilter 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"vPlanarDisplay\\\" 1 \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    -pluginObjects \\\"vRigWidget\\\" 1 \\n    -pluginObjects \\\"vChainDisplay\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t$configName;\n\n            setNamedPanelLayout (localizedPanelLabel(\"Current Layout\"));\n        }\n\n        panelHistory -e -clear mainPanelHistory;\n        setFocus `paneLayout -q -p1 $gMainPane`;\n        sceneUIReplacement -deleteRemaining;\n        sceneUIReplacement -clear;\n\t}\n\n\ngrid -spacing 5 -size 12 -divisions 5 -displayAxes yes -displayGridLines yes -displayDivisionLines yes -displayPerspectiveLabels no -displayOrthographicLabels no -displayAxesBold yes -perspectiveLabelPosition axis -orthographicLabelPosition edge;\nviewManip -drawCompass 0 -compassAngle 0 -frontParameters \"\" -homeParameters \"\" -selectionLockParameters \"\";\n}\n");
	setAttr ".st" 3;
createNode script -n "sceneConfigurationScriptNode1";
	rename -uid "340750E3-4D0F-70F2-E423-6F8F9AB89686";
	setAttr ".b" -type "string" "playbackOptions -min 1 -max 200 -ast 1 -aet 200 ";
	setAttr ".st" 6;
createNode vstExportNode -n "breakingcrate_dest_break_exportNode";
	rename -uid "253B7E0E-4838-F2E0-293A-878A94B10A4C";
	setAttr ".ei[0].exportFile" -type "string" "breakingcrate_dest_break_c";
	setAttr ".ei[0].t" 2;
	setAttr ".ei[0].fs" 1;
	setAttr ".ei[0].fe" 200;
createNode pairBlend -n "translateRotate13";
	rename -uid "8EAB31F5-49BA-4DEA-76AE-58A2754F4022";
createNode animCurveTL -n "translateRotate13_inTranslateY1";
	rename -uid "86E014B2-4087-B025-4663-F08C1118E4B1";
	setAttr ".tan" 3;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  100 -5 200 -250;
	setAttr -s 2 ".kit[1]"  2;
	setAttr -s 2 ".kot[1]"  2;
select -ne :time1;
	setAttr -av -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -av -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".o" 1;
	setAttr -av ".unw" 1;
	setAttr -k on ".etw";
	setAttr -k on ".tps";
	setAttr -k on ".tms";
select -ne :hardwareRenderingGlobals;
	setAttr ".otfna" -type "stringArray" 22 "NURBS Curves" "NURBS Surfaces" "Polygons" "Subdiv Surface" "Particles" "Particle Instance" "Fluids" "Strokes" "Image Planes" "UI" "Lights" "Cameras" "Locators" "Joints" "IK Handles" "Deformers" "Motion Trails" "Components" "Hair Systems" "Follicles" "Misc. UI" "Ornaments"  ;
	setAttr ".otfva" -type "Int32Array" 22 0 1 1 1 1 1
		 1 1 1 0 0 0 0 0 0 0 0 0
		 0 0 0 0 ;
	setAttr ".fprt" yes;
select -ne :renderPartition;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 4 ".st";
	setAttr -cb on ".an";
	setAttr -cb on ".pt";
select -ne :renderGlobalsList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
select -ne :defaultShaderList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 6 ".s";
select -ne :postProcessList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 2 ".p";
select -ne :defaultRenderUtilityList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 2 ".u";
select -ne :defaultRenderingList1;
	setAttr -s 3 ".r";
select -ne :defaultTextureList1;
select -ne :initialShadingGroup;
	setAttr -av -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -av -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 83 ".dsm";
	setAttr -k on ".mwc";
	setAttr -cb on ".an";
	setAttr -cb on ".il";
	setAttr -cb on ".vo";
	setAttr -cb on ".eo";
	setAttr -cb on ".fo";
	setAttr -cb on ".epo";
	setAttr -k on ".ro" yes;
	setAttr -s 13 ".gn";
select -ne :initialParticleSE;
	setAttr ".ro" yes;
select -ne :defaultRenderGlobals;
	setAttr ".fs" 1;
	setAttr ".ef" 10;
select -ne :defaultResolution;
	setAttr ".pa" 1;
select -ne :hardwareRenderGlobals;
	setAttr ".ctrs" 256;
	setAttr ".btrs" 512;
connectAttr "breakingcrate_destRN.phl[1]" "breakingcrate_dest_break_exportNode.ei[0].objects[0]"
		;
connectAttr "breakingcrate_destRN.phl[2]" "breakingcrate_dest_break_exportNode.ei[0].objects[1]"
		;
connectAttr "breakingcrate_destRN.phl[3]" "breakingcrate_dest_break_exportNode.ei[0].objects[2]"
		;
connectAttr "breakingcrate_destRN.phl[4]" "breakingcrate_dest_break_exportNode.ei[0].objects[3]"
		;
connectAttr "breakingcrate_destRN.phl[5]" "breakingcrate_dest_break_exportNode.ei[0].objects[4]"
		;
connectAttr "breakingcrate_destRN.phl[6]" "breakingcrate_dest_break_exportNode.ei[0].objects[5]"
		;
connectAttr "breakingcrate_destRN.phl[7]" "breakingcrate_dest_break_exportNode.ei[0].objects[6]"
		;
connectAttr "breakingcrate_destRN.phl[8]" "breakingcrate_dest_break_exportNode.ei[0].objects[7]"
		;
connectAttr "breakingcrate_destRN.phl[9]" "breakingcrate_dest_break_exportNode.ei[0].objects[8]"
		;
connectAttr "breakingcrate_destRN.phl[10]" "breakingcrate_dest_break_exportNode.ei[0].objects[9]"
		;
connectAttr "breakingcrate_destRN.phl[11]" "breakingcrate_dest_break_exportNode.ei[0].objects[10]"
		;
connectAttr "breakingcrate_destRN.phl[12]" "breakingcrate_dest_break_exportNode.ei[0].objects[11]"
		;
connectAttr "breakingcrate_destRN.phl[13]" "breakingcrate_dest_break_exportNode.ei[0].objects[12]"
		;
connectAttr "translateRotate.otx" "breakingcrate_destRN.phl[14]";
connectAttr "translateRotate.oty" "breakingcrate_destRN.phl[15]";
connectAttr "translateRotate.otz" "breakingcrate_destRN.phl[16]";
connectAttr "breakingcrate_destRN.phl[17]" "bulletRigidBodyShape1.ptrs";
connectAttr "translateRotate.orx" "breakingcrate_destRN.phl[18]";
connectAttr "translateRotate.ory" "breakingcrate_destRN.phl[19]";
connectAttr "translateRotate.orz" "breakingcrate_destRN.phl[20]";
connectAttr "breakingcrate_destRN.phl[21]" "bulletRigidBodyShape1.inwmat";
connectAttr "breakingcrate_destRN.phl[22]" "bulletRigidBodyShape1.inpim";
connectAttr "breakingcrate_destRN.phl[23]" "bulletRigidBodyShape1.imesh";
connectAttr "translateRotate1.otx" "breakingcrate_destRN.phl[24]";
connectAttr "translateRotate1.oty" "breakingcrate_destRN.phl[25]";
connectAttr "translateRotate1.otz" "breakingcrate_destRN.phl[26]";
connectAttr "breakingcrate_destRN.phl[27]" "bulletRigidBodyShape2.ptrs";
connectAttr "translateRotate1.orx" "breakingcrate_destRN.phl[28]";
connectAttr "translateRotate1.ory" "breakingcrate_destRN.phl[29]";
connectAttr "translateRotate1.orz" "breakingcrate_destRN.phl[30]";
connectAttr "breakingcrate_destRN.phl[31]" "bulletRigidBodyShape2.inwmat";
connectAttr "breakingcrate_destRN.phl[32]" "bulletRigidBodyShape2.inpim";
connectAttr "translateRotate2.otx" "breakingcrate_destRN.phl[33]";
connectAttr "translateRotate2.oty" "breakingcrate_destRN.phl[34]";
connectAttr "translateRotate2.otz" "breakingcrate_destRN.phl[35]";
connectAttr "breakingcrate_destRN.phl[36]" "bulletRigidBodyShape3.ptrs";
connectAttr "translateRotate2.orx" "breakingcrate_destRN.phl[37]";
connectAttr "translateRotate2.ory" "breakingcrate_destRN.phl[38]";
connectAttr "translateRotate2.orz" "breakingcrate_destRN.phl[39]";
connectAttr "breakingcrate_destRN.phl[40]" "bulletRigidBodyShape3.inwmat";
connectAttr "breakingcrate_destRN.phl[41]" "bulletRigidBodyShape3.inpim";
connectAttr "translateRotate3.otx" "breakingcrate_destRN.phl[42]";
connectAttr "translateRotate3.oty" "breakingcrate_destRN.phl[43]";
connectAttr "translateRotate3.otz" "breakingcrate_destRN.phl[44]";
connectAttr "breakingcrate_destRN.phl[45]" "bulletRigidBodyShape4.ptrs";
connectAttr "translateRotate3.orx" "breakingcrate_destRN.phl[46]";
connectAttr "translateRotate3.ory" "breakingcrate_destRN.phl[47]";
connectAttr "translateRotate3.orz" "breakingcrate_destRN.phl[48]";
connectAttr "breakingcrate_destRN.phl[49]" "bulletRigidBodyShape4.inwmat";
connectAttr "breakingcrate_destRN.phl[50]" "bulletRigidBodyShape4.inpim";
connectAttr "translateRotate4.otx" "breakingcrate_destRN.phl[51]";
connectAttr "translateRotate4.oty" "breakingcrate_destRN.phl[52]";
connectAttr "translateRotate4.otz" "breakingcrate_destRN.phl[53]";
connectAttr "breakingcrate_destRN.phl[54]" "bulletRigidBodyShape5.ptrs";
connectAttr "translateRotate4.orx" "breakingcrate_destRN.phl[55]";
connectAttr "translateRotate4.ory" "breakingcrate_destRN.phl[56]";
connectAttr "translateRotate4.orz" "breakingcrate_destRN.phl[57]";
connectAttr "breakingcrate_destRN.phl[58]" "bulletRigidBodyShape5.inwmat";
connectAttr "breakingcrate_destRN.phl[59]" "bulletRigidBodyShape5.inpim";
connectAttr "translateRotate5.otx" "breakingcrate_destRN.phl[60]";
connectAttr "translateRotate5.oty" "breakingcrate_destRN.phl[61]";
connectAttr "translateRotate5.otz" "breakingcrate_destRN.phl[62]";
connectAttr "breakingcrate_destRN.phl[63]" "bulletRigidBodyShape6.ptrs";
connectAttr "translateRotate5.orx" "breakingcrate_destRN.phl[64]";
connectAttr "translateRotate5.ory" "breakingcrate_destRN.phl[65]";
connectAttr "translateRotate5.orz" "breakingcrate_destRN.phl[66]";
connectAttr "breakingcrate_destRN.phl[67]" "bulletRigidBodyShape6.inwmat";
connectAttr "breakingcrate_destRN.phl[68]" "bulletRigidBodyShape6.inpim";
connectAttr "translateRotate6.otx" "breakingcrate_destRN.phl[69]";
connectAttr "translateRotate6.oty" "breakingcrate_destRN.phl[70]";
connectAttr "translateRotate6.otz" "breakingcrate_destRN.phl[71]";
connectAttr "breakingcrate_destRN.phl[72]" "bulletRigidBodyShape7.ptrs";
connectAttr "translateRotate6.orx" "breakingcrate_destRN.phl[73]";
connectAttr "translateRotate6.ory" "breakingcrate_destRN.phl[74]";
connectAttr "translateRotate6.orz" "breakingcrate_destRN.phl[75]";
connectAttr "breakingcrate_destRN.phl[76]" "bulletRigidBodyShape7.inwmat";
connectAttr "breakingcrate_destRN.phl[77]" "bulletRigidBodyShape7.inpim";
connectAttr "translateRotate7.otx" "breakingcrate_destRN.phl[78]";
connectAttr "translateRotate7.oty" "breakingcrate_destRN.phl[79]";
connectAttr "translateRotate7.otz" "breakingcrate_destRN.phl[80]";
connectAttr "breakingcrate_destRN.phl[81]" "bulletRigidBodyShape8.ptrs";
connectAttr "translateRotate7.orx" "breakingcrate_destRN.phl[82]";
connectAttr "translateRotate7.ory" "breakingcrate_destRN.phl[83]";
connectAttr "translateRotate7.orz" "breakingcrate_destRN.phl[84]";
connectAttr "breakingcrate_destRN.phl[85]" "bulletRigidBodyShape8.inwmat";
connectAttr "breakingcrate_destRN.phl[86]" "bulletRigidBodyShape8.inpim";
connectAttr "translateRotate8.otx" "breakingcrate_destRN.phl[87]";
connectAttr "translateRotate8.oty" "breakingcrate_destRN.phl[88]";
connectAttr "translateRotate8.otz" "breakingcrate_destRN.phl[89]";
connectAttr "breakingcrate_destRN.phl[90]" "bulletRigidBodyShape9.ptrs";
connectAttr "translateRotate8.orx" "breakingcrate_destRN.phl[91]";
connectAttr "translateRotate8.ory" "breakingcrate_destRN.phl[92]";
connectAttr "translateRotate8.orz" "breakingcrate_destRN.phl[93]";
connectAttr "breakingcrate_destRN.phl[94]" "bulletRigidBodyShape9.inwmat";
connectAttr "breakingcrate_destRN.phl[95]" "bulletRigidBodyShape9.inpim";
connectAttr "translateRotate9.otx" "breakingcrate_destRN.phl[96]";
connectAttr "translateRotate9.oty" "breakingcrate_destRN.phl[97]";
connectAttr "translateRotate9.otz" "breakingcrate_destRN.phl[98]";
connectAttr "breakingcrate_destRN.phl[99]" "bulletRigidBodyShape10.ptrs";
connectAttr "translateRotate9.orx" "breakingcrate_destRN.phl[100]";
connectAttr "translateRotate9.ory" "breakingcrate_destRN.phl[101]";
connectAttr "translateRotate9.orz" "breakingcrate_destRN.phl[102]";
connectAttr "breakingcrate_destRN.phl[103]" "bulletRigidBodyShape10.inwmat";
connectAttr "breakingcrate_destRN.phl[104]" "bulletRigidBodyShape10.inpim";
connectAttr "translateRotate10.otx" "breakingcrate_destRN.phl[105]";
connectAttr "translateRotate10.oty" "breakingcrate_destRN.phl[106]";
connectAttr "translateRotate10.otz" "breakingcrate_destRN.phl[107]";
connectAttr "breakingcrate_destRN.phl[108]" "bulletRigidBodyShape11.ptrs";
connectAttr "translateRotate10.orx" "breakingcrate_destRN.phl[109]";
connectAttr "translateRotate10.ory" "breakingcrate_destRN.phl[110]";
connectAttr "translateRotate10.orz" "breakingcrate_destRN.phl[111]";
connectAttr "breakingcrate_destRN.phl[112]" "bulletRigidBodyShape11.inwmat";
connectAttr "breakingcrate_destRN.phl[113]" "bulletRigidBodyShape11.inpim";
connectAttr "translateRotate11.otx" "breakingcrate_destRN.phl[114]";
connectAttr "translateRotate11.oty" "breakingcrate_destRN.phl[115]";
connectAttr "translateRotate11.otz" "breakingcrate_destRN.phl[116]";
connectAttr "breakingcrate_destRN.phl[117]" "bulletRigidBodyShape12.ptrs";
connectAttr "translateRotate11.orx" "breakingcrate_destRN.phl[118]";
connectAttr "translateRotate11.ory" "breakingcrate_destRN.phl[119]";
connectAttr "translateRotate11.orz" "breakingcrate_destRN.phl[120]";
connectAttr "breakingcrate_destRN.phl[121]" "bulletRigidBodyShape12.inwmat";
connectAttr "breakingcrate_destRN.phl[122]" "bulletRigidBodyShape12.inpim";
connectAttr "translateRotate12.otx" "breakingcrate_destRN.phl[123]";
connectAttr "translateRotate12.oty" "breakingcrate_destRN.phl[124]";
connectAttr "translateRotate12.otz" "breakingcrate_destRN.phl[125]";
connectAttr "breakingcrate_destRN.phl[126]" "bulletRigidBodyShape13.ptrs";
connectAttr "translateRotate12.orx" "breakingcrate_destRN.phl[127]";
connectAttr "translateRotate12.ory" "breakingcrate_destRN.phl[128]";
connectAttr "translateRotate12.orz" "breakingcrate_destRN.phl[129]";
connectAttr "breakingcrate_destRN.phl[130]" "bulletRigidBodyShape13.inwmat";
connectAttr "breakingcrate_destRN.phl[131]" "bulletRigidBodyShape13.inpim";
connectAttr ":time1.o" "bulletSolverShape1.ct";
connectAttr "bulletRigidBodyShape1.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape2.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape3.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape4.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape5.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape6.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape7.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape8.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape9.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape10.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape11.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape12.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape13.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "bulletRigidBodyShape14.rbdata" "bulletSolverShape1.rb" -na;
connectAttr "translateRotate13.otx" "ground.tx";
connectAttr "translateRotate13.oty" "ground.ty";
connectAttr "translateRotate13.otz" "ground.tz";
connectAttr "translateRotate13.orx" "ground.rx";
connectAttr "translateRotate13.ory" "ground.ry";
connectAttr "translateRotate13.orz" "ground.rz";
connectAttr "ground.wm" "bulletRigidBodyShape14.inwmat";
connectAttr "ground.pim" "bulletRigidBodyShape14.inpim";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape14.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape14.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape14.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape14.ct";
connectAttr "ground.rp" "bulletRigidBodyShape14.ptrs";
connectAttr "groundShape.o" "bulletRigidBodyShape14.imesh";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape13.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape13.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape13.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape13.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape12.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape12.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape12.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape12.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape11.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape11.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape11.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape11.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape10.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape10.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape10.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape10.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape9.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape9.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape9.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape9.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape8.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape8.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape8.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape8.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape7.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape7.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape7.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape7.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape6.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape6.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape6.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape6.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape5.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape5.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape5.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape5.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape4.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape4.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape4.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape4.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape3.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape3.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape3.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape3.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape2.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape2.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape2.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape2.ct";
connectAttr "bulletSolverShape1.solinitdata" "bulletRigidBodyShape1.solinit";
connectAttr "bulletSolverShape1.soldata" "bulletRigidBodyShape1.solup";
connectAttr "bulletSolverShape1.st" "bulletRigidBodyShape1.st";
connectAttr "bulletSolverShape1.ct" "bulletRigidBodyShape1.ct";
relationship "link" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
connectAttr "layerManager.dli[0]" "defaultLayer.id";
connectAttr "renderLayerManager.rlmi[0]" "defaultRenderLayer.rlid";
connectAttr "breakingcrate_destRNfosterParent1.msg" "breakingcrate_destRN.fp";
connectAttr "bulletRigidBodyShape1.sot" "translateRotate.it2";
connectAttr "bulletRigidBodyShape1.sor" "translateRotate.ir2";
connectAttr "bulletRigidBodyShape1.isdriven" "translateRotate.w";
connectAttr "bulletRigidBodyShape2.sot" "translateRotate1.it2";
connectAttr "bulletRigidBodyShape2.sor" "translateRotate1.ir2";
connectAttr "bulletRigidBodyShape2.isdriven" "translateRotate1.w";
connectAttr "bulletRigidBodyShape3.sot" "translateRotate2.it2";
connectAttr "bulletRigidBodyShape3.sor" "translateRotate2.ir2";
connectAttr "bulletRigidBodyShape3.isdriven" "translateRotate2.w";
connectAttr "bulletRigidBodyShape4.sot" "translateRotate3.it2";
connectAttr "bulletRigidBodyShape4.sor" "translateRotate3.ir2";
connectAttr "bulletRigidBodyShape4.isdriven" "translateRotate3.w";
connectAttr "bulletRigidBodyShape5.sot" "translateRotate4.it2";
connectAttr "bulletRigidBodyShape5.sor" "translateRotate4.ir2";
connectAttr "bulletRigidBodyShape5.isdriven" "translateRotate4.w";
connectAttr "bulletRigidBodyShape6.sot" "translateRotate5.it2";
connectAttr "bulletRigidBodyShape6.sor" "translateRotate5.ir2";
connectAttr "bulletRigidBodyShape6.isdriven" "translateRotate5.w";
connectAttr "bulletRigidBodyShape7.sot" "translateRotate6.it2";
connectAttr "bulletRigidBodyShape7.sor" "translateRotate6.ir2";
connectAttr "bulletRigidBodyShape7.isdriven" "translateRotate6.w";
connectAttr "bulletRigidBodyShape8.sot" "translateRotate7.it2";
connectAttr "bulletRigidBodyShape8.sor" "translateRotate7.ir2";
connectAttr "bulletRigidBodyShape8.isdriven" "translateRotate7.w";
connectAttr "bulletRigidBodyShape9.sot" "translateRotate8.it2";
connectAttr "bulletRigidBodyShape9.sor" "translateRotate8.ir2";
connectAttr "bulletRigidBodyShape9.isdriven" "translateRotate8.w";
connectAttr "bulletRigidBodyShape10.sot" "translateRotate9.it2";
connectAttr "bulletRigidBodyShape10.sor" "translateRotate9.ir2";
connectAttr "bulletRigidBodyShape10.isdriven" "translateRotate9.w";
connectAttr "bulletRigidBodyShape11.sot" "translateRotate10.it2";
connectAttr "bulletRigidBodyShape11.sor" "translateRotate10.ir2";
connectAttr "bulletRigidBodyShape11.isdriven" "translateRotate10.w";
connectAttr "bulletRigidBodyShape12.sot" "translateRotate11.it2";
connectAttr "bulletRigidBodyShape12.sor" "translateRotate11.ir2";
connectAttr "bulletRigidBodyShape12.isdriven" "translateRotate11.w";
connectAttr "bulletRigidBodyShape13.sot" "translateRotate12.it2";
connectAttr "bulletRigidBodyShape13.sor" "translateRotate12.ir2";
connectAttr "bulletRigidBodyShape13.isdriven" "translateRotate12.w";
connectAttr "bulletRigidBodyShape14.sot" "translateRotate13.it2";
connectAttr "bulletRigidBodyShape14.sor" "translateRotate13.ir2";
connectAttr "bulletRigidBodyShape14.isdriven" "translateRotate13.w";
connectAttr "translateRotate13_inTranslateY1.o" "translateRotate13.ity1";
connectAttr "defaultRenderLayer.msg" ":defaultRenderingList1.r" -na;
connectAttr "groundShape.iog" ":initialShadingGroup.dsm" -na;
// End of breakingcrate_dest_break.ma
