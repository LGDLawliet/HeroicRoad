//Maya ASCII 2016R2 scene
//Name: breakingcrate_dest.ma
//Last modified: Fri, Jun 02, 2017 05:53:07 PM
//Codeset: 1252
file -rdi 1 -ns "breakingcrate_vmat1" -rfn "breakingcrate_vmatRN1" -typ "mayaAscii"
		 "%VTOOLS%/maya/global/python/Materials/dota_hero_shaderfx.ma";
file -r -ns "breakingcrate_vmat1" -dr 1 -rfn "breakingcrate_vmatRN1" -typ "mayaAscii"
		 "%VTOOLS%/maya/global/python/Materials/dota_hero_shaderfx.ma";
requires maya "2016R2";
requires -nodeType "vsVmatToTex" "PVstVmatPlugin.py" "2.0";
requires -nodeType "vstExportNode" "PVstExportNode.py" "2.1.0";
requires "stereoCamera" "10.0";
requires "stereoCamera" "10.0";
currentUnit -l centimeter -a degree -t ntsc;
fileInfo "application" "maya";
fileInfo "product" "Maya 2016";
fileInfo "version" "2016 Extension 2";
fileInfo "cutIdentifier" "201603022110-988944-2";
fileInfo "osv" "Microsoft Windows 8 Business Edition, 64-bit  (Build 9200)\n";
createNode transform -s -n "persp";
	rename -uid "696C32DA-446B-9F0B-2BDF-C8A9C926EF99";
	setAttr ".v" no;
	setAttr ".t" -type "double3" -79.326134961711759 191.9347779769507 146.55963303239136 ;
	setAttr ".r" -type "double3" -42.3383527298475 690.19999999956076 1.8326119512649433e-015 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "3B3FF13C-4200-9401-A04D-28B478B4A4AA";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 218.69945043437053;
	setAttr ".imn" -type "string" "persp";
	setAttr ".den" -type "string" "persp_depth";
	setAttr ".man" -type "string" "persp_mask";
	setAttr ".tp" -type "double3" 0.58651542663574219 3.5190983936190605 0 ;
	setAttr ".hc" -type "string" "viewSet -p %camera";
createNode transform -s -n "top";
	rename -uid "7B743193-4D87-C149-17A6-339DB672B3F0";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 1000.1 0 ;
	setAttr ".r" -type "double3" -89.999999999999986 0 0 ;
createNode camera -s -n "topShape" -p "top";
	rename -uid "B5243BB1-4A67-95A6-242B-D38E1409CF8F";
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
	rename -uid "B78B8CBC-462D-49D8-F852-DBBA43EC0652";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 0 1000.1 ;
createNode camera -s -n "frontShape" -p "front";
	rename -uid "72F5B7D6-4B33-60F9-8DE4-248304A00D95";
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
	rename -uid "B14C6305-404A-AB87-E36E-DC812F5F0C74";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 1000.1 0 0 ;
	setAttr ".r" -type "double3" 0 89.999999999999986 0 ;
createNode camera -s -n "sideShape" -p "side";
	rename -uid "E5B7023B-4728-5363-F898-77A9023B79F9";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 1000.1;
	setAttr ".ow" 30;
	setAttr ".imn" -type "string" "side";
	setAttr ".den" -type "string" "side_depth";
	setAttr ".man" -type "string" "side_mask";
	setAttr ".hc" -type "string" "viewSet -s %camera";
	setAttr ".o" yes;
createNode transform -n "breakingcrate_joints";
	rename -uid "1CCA109C-4B61-9110-3BB2-399B914F07EA";
createNode joint -n "breakingcrate_joint1" -p "breakingcrate_joints";
	rename -uid "64B28658-4F62-7B3F-3A36-C88C77273E9D";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".bps" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0.58651542663574219 3.519098393619061 0 1;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint1_parentConstraint1" -p "breakingcrate_joint1";
	rename -uid "4FDA04C7-4C02-57F9-A626-8A93105A9EEB";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc1W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 4.4408920985006262e-016 0 ;
	setAttr ".rst" -type "double3" 0.58651542663574219 3.519098393619061 0 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint2" -p "breakingcrate_joints";
	rename -uid "DF5008E8-40A2-BC61-E248-E989B37603B1";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint2_parentConstraint1" -p "breakingcrate_joint2";
	rename -uid "3B235BA1-41A1-5298-C0C7-AA8EEE89088B";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc2W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" -1.7763568394002505e-015 7.1054273576010019e-015 
		0 ;
	setAttr ".rst" -type "double3" -10.957788467407228 55.005126953125007 36.663144111633301 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint3" -p "breakingcrate_joints";
	rename -uid "F4E485B2-4D26-2BF7-1CAB-C4A044D5EAB4";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint3_parentConstraint1" -p "breakingcrate_joint3";
	rename -uid "AE584F58-4E36-2C02-BC12-C28F420C955A";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc3W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 1.7763568394002505e-015 0 0 ;
	setAttr ".rst" -type "double3" -13.207149505615233 23.346709251403809 36.663144111633301 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint4" -p "breakingcrate_joints";
	rename -uid "E894A905-4AF5-6FD0-9A68-EAB10C2C63C0";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint4_parentConstraint1" -p "breakingcrate_joint4";
	rename -uid "C1C6490C-4893-C8A5-7883-FB8F233B8AD3";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc4W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".rst" -type "double3" 7.9282169342041016 43.402218818664551 36.663144111633301 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint5" -p "breakingcrate_joints";
	rename -uid "A068DB96-4F9A-1314-FF64-C5A667343D42";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint5_parentConstraint1" -p "breakingcrate_joint5";
	rename -uid "4A5E0DD6-4C5D-8335-AD6B-ACA93870C9AF";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc5W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 -1.4210854715202004e-014 1.1102230246251565e-016 ;
	setAttr ".rst" -type "double3" 8.8519010543823242 82.218948364257798 -0.58651733398437489 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint6" -p "breakingcrate_joints";
	rename -uid "0AD1ABC6-4F5D-EC3D-FACE-67BD8206E0C8";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint6_parentConstraint1" -p "breakingcrate_joint6";
	rename -uid "6BCD1EBC-40FC-B64E-81A5-3C871E086CDD";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc6W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".rst" -type "double3" 37.029716491699219 43.402213335037231 12.228683948516846 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint7" -p "breakingcrate_joints";
	rename -uid "D801BA7F-4369-649F-9240-268F500A71E5";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint7_parentConstraint1" -p "breakingcrate_joint7";
	rename -uid "75AF2AF2-474F-AF87-7885-2F80B5D185DC";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc7W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 0 -1.7763568394002505e-015 ;
	setAttr ".rst" -type "double3" 37.029716491699219 43.402213335037231 -14.332284450531008 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint8" -p "breakingcrate_joints";
	rename -uid "859EBDBF-447D-AEF9-9884-3385C2BFD07F";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint8_parentConstraint1" -p "breakingcrate_joint8";
	rename -uid "BE374867-4A32-7E39-584C-A0B678C559B8";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc8W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" -8.8817841970012523e-016 0 0 ;
	setAttr ".rst" -type "double3" 7.154974937438964 43.402216911315918 -36.956401824951172 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint9" -p "breakingcrate_joints";
	rename -uid "4EBBBE65-4280-5DA5-3C89-DDA462D8AF71";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint9_parentConstraint1" -p "breakingcrate_joint9";
	rename -uid "9016B2C0-4C02-5429-9557-349180F34047";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc9W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 -3.5527136788005009e-015 7.1054273576010019e-015 ;
	setAttr ".rst" -type "double3" -17.808063745498657 25.081090211868283 -37.249660491943352 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint10" -p "breakingcrate_joints";
	rename -uid "6910529A-478C-E7B8-33AE-7FAA3A89CD18";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint10_parentConstraint1" -p "breakingcrate_joint10";
	rename -uid "59983CC1-43D7-184C-0410-D09D20A6B339";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc10W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 7.1054273576010019e-015 0 ;
	setAttr ".rst" -type "double3" -6.5793962478637695 58.13042068481446 -36.956401824951172 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint11" -p "breakingcrate_joints";
	rename -uid "F39F214C-4494-0D22-7E3E-3D97AA397376";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint11_parentConstraint1" -p "breakingcrate_joint11";
	rename -uid "1D28E5CC-46A3-47F9-F90C-5D8F4555629C";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc11W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 0 -2.1684043449710089e-019 ;
	setAttr ".rst" -type "double3" -9.5819339752197266 82.25341796875 -0.0014324188232421877 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint12" -p "breakingcrate_joints";
	rename -uid "BAB02E6C-494A-8B92-2400-398BAACF7491";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint12_parentConstraint1" -p "breakingcrate_joint12";
	rename -uid "D12E2CC0-49F5-39D8-A0D8-EAA0E2ACB866";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc12W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 -7.1054273576010019e-015 1.7763568394002505e-015 ;
	setAttr ".rst" -type "double3" -36.44320011138916 43.402213335037224 -14.213162899017332 ;
	setAttr -k on ".w0";
createNode joint -n "breakingcrate_joint13" -p "breakingcrate_joints";
	rename -uid "1BCFDBEC-439A-E847-941B-77BE85AF8575";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".radi" 0.5;
createNode parentConstraint -n "breakingcrate_joint13_parentConstraint1" -p "breakingcrate_joint13";
	rename -uid "4249117D-483F-B6F5-1A15-C2950207BA27";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_loc13W0" -dv 1 -min 
		0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 -7.1054273576010019e-015 0 ;
	setAttr ".rst" -type "double3" -36.44320011138916 43.402213335037224 9.9553966522216797 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_geo";
	rename -uid "F16E9FA6-42C3-7D80-DEEB-11B1FBC0AC1C";
createNode transform -n "breakingcrate_mesh1" -p "breakingcrate_geo";
	rename -uid "D52E7006-4AAC-063C-ECB9-7192F5A5B3FF";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" 0.58651542663574219 3.5190983936190605 0 ;
	setAttr ".sp" -type "double3" 0.58651542663574219 3.5190983936190605 0 ;
createNode mesh -n "breakingcrate_mesh1Shape" -p "breakingcrate_mesh1";
	rename -uid "5158905A-4F96-F58B-ECAD-8CA885B75FF0";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh1ShapeOrig" -p "breakingcrate_mesh1";
	rename -uid "2C17A0EA-48C4-8568-55C0-8280E5FA9894";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 168 ".uvst[0].uvsp[0:167]" -type "float2" 0.76762003 0.27269399
		 0.76762003 0.37793601 0.73653603 0.37793601 0.73653603 0.27269399 0.93878698 0.81309199
		 0.93878698 0.91833502 0.93167901 0.91833502 0.93167901 0.81309199 0.36876401 0.238168
		 0.399849 0.238168 0.399849 0.243108 0.36876401 0.243108 0.95119399 0.91648501 0.95119399
		 0.76505703 0.95613301 0.76505703 0.95613301 0.91648501 0.51287103 0.52788198 0.54395503
		 0.52788198 0.54395503 0.532821 0.51287103 0.532821 0.127086 0.547396 0.18096299 0.547396
		 0.18096299 0.80985898 0.127086 0.80985898 0.73309398 0.27269399 0.73309398 0.37793601
		 0.70200998 0.37793601 0.70200998 0.27269399 0.94178897 0.017506 0.94178897 0.122748
		 0.93468201 0.122748 0.93468201 0.017506 0.61344498 0.461833 0.64452899 0.461833 0.64452899
		 0.466773 0.61344498 0.466773 0.93487799 0.79759401 0.82830799 0.79794198 0.82810301
		 0.790923 0.93467402 0.79057503 0.40329 0.238168 0.434374 0.238168 0.434374 0.243108
		 0.40329 0.243108 0.29654801 0.27246299 0.242672 0.27246299 0.242672 0.0099999998
		 0.29654801 0.0099999998 0.76461798 0.81309199 0.76461798 0.91833502 0.73353302 0.91833502
		 0.73353302 0.81309199 0.94685501 0.60404003 0.84161299 0.60404003 0.84161299 0.59693301
		 0.94685501 0.59693301 0.54139203 0.238168 0.57247603 0.238168 0.57247603 0.243108
		 0.54139203 0.243108 0.947065 0.76505703 0.94730699 0.91839498 0.94242901 0.91869003
		 0.94218701 0.765351 0.56351 0.500862 0.56351 0.52246499 0.55640298 0.52246499 0.55640298
		 0.500862 0.238005 0.80985802 0.184128 0.80985802 0.184128 0.547396 0.238005 0.547396
		 0.73309398 0.382274 0.73309398 0.487517 0.70200998 0.487517 0.70200998 0.382274 0.979348
		 0.646734 0.96568799 0.75324398 0.95869899 0.75297898 0.972359 0.646469 0.51247299
		 0.82510102 0.51247299 0.84670401 0.50536501 0.84670401 0.50536501 0.82510102 0.95886397
		 0.982319 0.85362202 0.982319 0.85362202 0.97521102 0.95886397 0.97521102 0.50686598
		 0.238168 0.53794998 0.238168 0.53794998 0.243108 0.50686598 0.243108 0.29955 0.53815901
		 0.245674 0.53815901 0.245674 0.27569601 0.29955 0.27569601 0.80425 0.98123902 0.69900799
		 0.98123902 0.69900799 0.95419598 0.80425 0.95419598 0.95886397 0.93728602 0.85362202
		 0.93728602 0.85362202 0.93017799 0.95886397 0.93017799 0.51287103 0.500862 0.53991401
		 0.500862 0.53991401 0.50580198 0.51287103 0.50580198 0.961303 0.14359801 0.961303
		 0.248841 0.95419598 0.248841 0.95419598 0.14359801 0.53388602 0.79808098 0.56093001
		 0.79808098 0.56093001 0.80302101 0.53388602 0.80302101 0.27569601 0.92150998 0.27569601
		 0.87463701 0.53815901 0.87463701 0.53815901 0.92150998 0.84266698 0.68099499 0.84266698
		 0.786237 0.82059699 0.786237 0.82059699 0.68099499 0.94685501 0.61454803 0.84161299
		 0.61454803 0.84161299 0.60743999 0.94685501 0.60743999 0.508367 0.78457099 0.53043699
		 0.78457099 0.53043699 0.78951102 0.508367 0.78951102 0.95220798 0.017506 0.952555
		 0.124076 0.94553697 0.12428 0.945189 0.01771 0.508367 0.80258399 0.53043699 0.80258399
		 0.53043699 0.80752403 0.508367 0.80752403 0.60966599 0.53515601 0.57141399 0.53515601
		 0.57141399 0.27269399 0.60966599 0.27269399 0.76461798 0.0099999998 0.76461798 0.115243
		 0.73353302 0.115243 0.73353302 0.0099999998 0.95269501 0.436131 0.95269501 0.284702
		 0.95763499 0.284702 0.95763499 0.436131 0.51287103 0.518875 0.54395503 0.518875 0.54395503
		 0.52381498 0.51287103 0.52381498 0.93878698 0.32973599 0.93878698 0.43497801 0.93167901
		 0.43497801 0.93167901 0.32973599 0.4689 0.243108 0.43781501 0.243108 0.43781501 0.238168
		 0.4689 0.238168 0.185629 0.0099999998 0.23950601 0.0099999998 0.23950601 0.27246201
		 0.185629 0.27246201;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 56 ".vt[0:55]"  -17.74212265 3.35634303 -37.14408875 -17.74212265 -0.130502 -37.14408875
		 -32.99155045 3.35634303 -37.14408875 -32.99155045 -0.130502 -37.14408875 -17.74212265 3.35634303 37.14408875
		 -17.74212265 -0.130502 37.14408875 -32.99155045 3.35634303 37.14408875 -32.99155045 -0.130502 37.14408875
		 37.73060226 7.16869879 36.80390549 37.73060226 7.16869879 21.5544796 37.73060226 3.68185496 36.80390549
		 37.73060226 3.68185496 21.5544796 -36.55757141 7.16869879 36.80390549 -36.55757141 7.16869879 21.5544796
		 -36.55757141 3.68185496 36.80390549 -36.55757141 3.68185496 21.5544796 37.73060226 7.16869879 20.38144684
		 37.73060226 7.16869879 5.13201904 37.73060226 3.68185496 20.38144684 37.73060226 3.68185496 5.13201904
		 -36.55757141 7.16869879 20.38144684 -36.55757141 7.16869879 5.13201904 -36.55757141 3.68185496 20.38144684
		 -36.55757141 3.68185496 5.13201904 37.73060226 7.16869879 -21.5544796 37.73060226 7.16869879 -36.80390549
		 37.73060226 3.68185496 -21.5544796 37.73060226 3.68185496 -36.80390549 -36.55757141 7.16869879 -21.5544796
		 -36.55757141 7.16869879 -36.80390549 -36.55757141 3.68185496 -21.5544796 -36.55757141 3.68185496 -36.80390549
		 37.73060226 7.16869879 -21.14978409 37.73060226 3.68185496 -21.14978409 -36.55757141 7.16869879 -21.14978409
		 -36.55757141 3.68185496 -21.14978409 37.73060226 7.16869879 -7.88278103 37.73060226 3.68185496 -7.88278103
		 -36.55757141 7.16869879 -7.88278103 -36.55757141 3.68185496 -7.88278103 37.73060226 7.16869879 -6.73320913
		 37.73060226 3.68185496 -6.73320913 -36.55757141 7.16869879 -6.73320913 -36.55757141 3.68185496 -6.73320913
		 37.73060226 7.16869879 4.093883991 37.73060226 3.68185496 4.093883991 -36.55757141 7.16869879 4.093883991
		 -36.55757141 3.68185496 4.093883991 34.75109863 3.35634303 -37.14408875 34.75109863 -0.130502 -37.14408875
		 19.50167084 3.35634303 -37.14408875 19.50167084 -0.130502 -37.14408875 34.75109863 3.35634303 37.14408875
		 34.75109863 -0.130502 37.14408875 19.50167084 3.35634303 37.14408875 19.50167084 -0.130502 37.14408875;
	setAttr -s 84 ".ed[0:83]"  4 0 0 0 2 0 2 6 0 6 4 0 5 1 0 1 0 0 4 5 0
		 1 3 0 3 2 0 3 7 0 7 6 0 7 5 0 12 8 0 8 9 0 9 13 0 13 12 0 14 10 0 10 8 0 12 14 0
		 10 11 0 11 9 0 11 15 0 15 13 0 15 14 0 20 16 0 16 17 0 17 21 0 21 20 0 22 18 0 18 16 0
		 20 22 0 18 19 0 19 17 0 19 23 0 23 21 0 23 22 0 28 24 0 24 25 0 25 29 0 29 28 0 30 26 0
		 26 24 0 28 30 0 26 27 0 27 25 0 27 31 0 31 29 0 31 30 0 38 36 0 36 32 0 32 34 0 34 38 0
		 39 37 0 37 36 0 38 39 0 37 33 0 33 32 0 33 35 0 35 34 0 35 39 0 46 44 0 44 40 0 40 42 0
		 42 46 0 47 45 0 45 44 0 46 47 0 45 41 0 41 40 0 41 43 0 43 42 0 43 47 0 52 48 0 48 50 0
		 50 54 0 54 52 0 53 49 0 49 48 0 52 53 0 49 51 0 51 50 0 51 55 0 55 54 0 55 53 0;
	setAttr -s 168 ".n";
	setAttr ".n[0:165]" -type "float3"  0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1
		 0 0 1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 1 0 0 1 0 0
		 1 0 0 1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0
		 1 1 0 0 1 0 0 1 0 0 1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 1 0 0
		 1 0 0 1 0 0 1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 1 0 0 1 0 0
		 1 0 0 1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 1 0 0 1 0 0 1 0 0 1
		 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0
		 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 1 0 0 1 0 0 1 0 0 1 0 0 0
		 0 -1 0 0 -1 0 0 -1 0 0 -1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0
		 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 -1 0 0 -1 0;
	setAttr ".n[166:167]" -type "float3"  0 -1 0 0 -1 0;
	setAttr -s 42 -ch 168 ".fc[0:41]" -type "polyFaces" 
		f 4 0 1 2 3
		mu 0 4 0 1 2 3
		f 4 4 5 -1 6
		mu 0 4 4 5 6 7
		f 4 7 8 -2 -6
		mu 0 4 8 9 10 11
		f 4 9 10 -3 -9
		mu 0 4 12 13 14 15
		f 4 11 -7 -4 -11
		mu 0 4 16 17 18 19
		f 4 -12 -10 -8 -5
		mu 0 4 20 21 22 23
		f 4 12 13 14 15
		mu 0 4 24 25 26 27
		f 4 16 17 -13 18
		mu 0 4 28 29 30 31
		f 4 19 20 -14 -18
		mu 0 4 32 33 34 35
		f 4 21 22 -15 -21
		mu 0 4 36 37 38 39
		f 4 23 -19 -16 -23
		mu 0 4 40 41 42 43
		f 4 -24 -22 -20 -17
		mu 0 4 44 45 46 47
		f 4 24 25 26 27
		mu 0 4 48 49 50 51
		f 4 28 29 -25 30
		mu 0 4 52 53 54 55
		f 4 31 32 -26 -30
		mu 0 4 56 57 58 59
		f 4 33 34 -27 -33
		mu 0 4 60 61 62 63
		f 4 35 -31 -28 -35
		mu 0 4 64 65 66 67
		f 4 -36 -34 -32 -29
		mu 0 4 68 69 70 71
		f 4 36 37 38 39
		mu 0 4 72 73 74 75
		f 4 40 41 -37 42
		mu 0 4 76 77 78 79
		f 4 43 44 -38 -42
		mu 0 4 80 81 82 83
		f 4 45 46 -39 -45
		mu 0 4 84 85 86 87
		f 4 47 -43 -40 -47
		mu 0 4 88 89 90 91
		f 4 -48 -46 -44 -41
		mu 0 4 92 93 94 95
		f 4 48 49 50 51
		mu 0 4 96 97 98 99
		f 4 52 53 -49 54
		mu 0 4 100 101 102 103
		f 4 55 56 -50 -54
		mu 0 4 104 105 106 107
		f 4 57 58 -51 -57
		mu 0 4 108 109 110 111
		f 4 59 -55 -52 -59
		mu 0 4 112 113 114 115
		f 4 -60 -58 -56 -53
		mu 0 4 116 117 118 119
		f 4 60 61 62 63
		mu 0 4 120 121 122 123
		f 4 64 65 -61 66
		mu 0 4 124 125 126 127
		f 4 67 68 -62 -66
		mu 0 4 128 129 130 131
		f 4 69 70 -63 -69
		mu 0 4 132 133 134 135
		f 4 71 -67 -64 -71
		mu 0 4 136 137 138 139
		f 4 -72 -70 -68 -65
		mu 0 4 140 141 142 143
		f 4 72 73 74 75
		mu 0 4 144 145 146 147
		f 4 76 77 -73 78
		mu 0 4 148 149 150 151
		f 4 79 80 -74 -78
		mu 0 4 152 153 154 155
		f 4 81 82 -75 -81
		mu 0 4 156 157 158 159
		f 4 83 -79 -76 -83
		mu 0 4 160 161 162 163
		f 4 -84 -82 -80 -77
		mu 0 4 164 165 166 167;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh2" -p "breakingcrate_geo";
	rename -uid "9D125C7A-447E-F608-66AB-229B83EFAD1D";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" -10.957788467407227 55.005126953125 36.663144111633301 ;
	setAttr ".sp" -type "double3" -10.957788467407227 55.005126953125 36.663144111633301 ;
createNode mesh -n "breakingcrate_mesh2Shape" -p "breakingcrate_mesh2";
	rename -uid "4C5A9545-4F40-524D-051C-66993A1E94A2";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh2ShapeOrig" -p "breakingcrate_mesh2";
	rename -uid "9588F7F8-408F-2EBA-2CFA-039544A42446";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 181 ".uvst[0].uvsp[0:180]" -type "float2" 0.870134 0.740816
		 0.870134 0.674335 0.874394 0.67320299 0.88029599 0.66989702 0.88029599 0.740816 0.97220898
		 0.73353302 0.98237097 0.73353302 0.98237097 0.75550699 0.97220898 0.75550699 0.60894102
		 0.75454903 0.67433602 0.75454903 0.67949098 0.775029 0.68022603 0.778108 0.68019098
		 0.778947 0.67928302 0.78003597 0.67542303 0.786165 0.60894102 0.786165 0.068543002
		 0.19294 0.068543002 0.0099999998 0.123342 0.0099999998 0.123342 0.186864 0.112386
		 0.200018 0.092586003 0.20119999 0.870134 0.017506 0.87963998 0.017506 0.87963998
		 0.095926002 0.874147 0.091172002 0.870134 0.087415002 0.55443019 -0.3504321 0.55530411
		 -0.37329429 0.57917792 -0.36840886 0.57911342 -0.3667292 0.57059956 -0.31685227 0.55578816
		 -0.3197974 0.57941496 -0.35993022 0.55890727 -0.3822403 0.57306933 -0.3801403 0.57979822
		 -0.36994892 0.58158481 -0.31450421 0.58251125 -0.37955129 0.79636902 0.91944802 0.76805902
		 0.91944802 0.76805902 0.85622919 0.77141905 0.85378432 0.78115427 0.85577935 0.79261923
		 0.8590166 0.79543054 0.86126959 0.79636908 0.86260408 0.69750702 0.140441 0.69750702
		 0.134592 0.77929682 0.134592 0.7850706 0.13760757 0.78661311 0.13837405 0.78770792
		 0.140441 0.656977 0.44382 0.662826 0.44382 0.662826 0.47213 0.656977 0.47213 0.93108892
		 0.18673515 0.93108898 0.249954 0.92267299 0.249954 0.92267299 0.18947649 0.34728199
		 0.812635 0.29821199 0.812635 0.29821199 0.65629435 0.30121949 0.65507394 0.33213827
		 0.64595771 0.34728199 0.66181141 0.43950057 -0.45637119 0.43849671 -0.46150398 0.42232704
		 -0.45515418 0.42493734 -0.44180787 0.4353241 -0.40429842 0.44516921 -0.40429842 0.44516924
		 -0.43590021 0.452115 -0.41124421 0.43637511 -0.40056729 0.44261512 -0.40174437 0.45426178
		 -0.40429842 0.44516921 -0.40169358 0.45515552 -0.40162045 0.86713201 0.92679203 0.86713201
		 0.86770499 0.86925298 0.86758399 0.876638 0.86920202 0.87663698 0.92679203 0.983675
		 0.425807 0.983675 0.435969 0.96170199 0.435969 0.96170199 0.425807 0.60894102 0.71852201
		 0.66752899 0.71852201 0.67251098 0.73347402 0.67012 0.73996001 0.66644502 0.74694002
		 0.66421199 0.750139 0.60894102 0.750139 0.068543002 0.43000701 0.068543002 0.278698
		 0.123342 0.278698 0.123342 0.41304299 0.111793 0.42179301 0.083127998 0.43700001
		 0.85317898 0.703192 0.85317898 0.78749102 0.84611601 0.78749102 0.84611601 0.70019299
		 0.63450485 -0.40429842 0.65440422 -0.42602879 0.66761196 -0.41282105 0.65980709 -0.40429842
		 0.64299452 -0.37458187 0.6250422 -0.38757306 0.66254056 -0.43377483 0.67613459 -0.42668939
		 0.67613459 -0.42093545 0.68010199 -0.4241274 0.86391902 0.44916201 0.83560902 0.44916201
		 0.83560902 0.42210299 0.848867 0.41391999 0.86391902 0.408685 0.97311997 0.23902801
		 0.97311997 0.28103799 0.96470398 0.28103799 0.96470398 0.24056099 0.64175498 0.479846
		 0.64175498 0.48569599 0.61344498 0.48569599 0.61344498 0.479846 0.96020001 0.60297602
		 0.96020001 0.57591701 0.96861702 0.57591701 0.96861702 0.60593301 0.60894102 0.547396
		 0.65801102 0.547396 0.65801102 0.652165 0.62276399 0.63452703 0.60894102 0.62225097
		 0.58417714 -0.33972937 0.58212709 -0.38635415 0.60031837 -0.38519311 0.60183549 -0.35068217
		 0.60531914 -0.31758198 0.58627206 -0.31981915 0.299714 0.25317901 0.364342 0.25317901
		 0.373936 0.25817901 0.37527201 0.25978601 0.299714 0.25978601 0.976713 0.439316 0.986875
		 0.439316 0.986875 0.46129 0.976713 0.46129 0.66598397 0.37904999 0.66598397 0.34361601
		 0.68790501 0.34464201 0.69760001 0.33703399 0.69760001 0.37904999 0.127086 0.103714
		 0.127086 0.0099999998 0.181885 0.0099999998 0.181885 0.13250101 0.17013501 0.122067
		 0.15155099 0.101081 0.13010199 0.102526 0.84889603 0.25317901 0.84889603 0.26334101
		 0.81131798 0.26334101 0.81191099 0.262189 0.81346202 0.25317901 0.57138258 -0.30994767
		 0.56709433 -0.32641554 0.57272303 -0.32660115 0.5927369 -0.32485262 0.6000191 -0.30023277
		 0.57943696 -0.28271708 0.58145279 -0.25806245 0.60359037 -0.25655705 0.58421415 -0.25481763
		 0.5814572 -0.25485516;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 71 ".vt[0:70]"  -37.53705215 28.90206146 31.67188835 9.39053822 28.90206146 31.67188835
		 10.1895752 28.90206146 33.76191711 12.52313614 28.90206146 36.65727615 -37.53705215 28.90206146 36.65727615
		 -37.53705215 44.41249466 36.65727615 -37.53705215 44.41249466 31.67188835 8.6233263 44.41249466 31.67188835
		 12.26221657 34.36507416 31.67188835 12.78110409 32.85467148 31.67188835 12.75653267 32.44293976 31.67188835
		 12.11553383 31.90907288 31.67188835 14.24287701 44.41249466 36.65727615 16.24633408 32.0029792786 36.65727615
		 16.58078384 37.60721207 36.65727615 11.1037693 44.41249466 33.77646255 -37.33799744 81.10819244 37.52531815
		 -23.45404816 80.74462891 37.52531815 -24.62218475 36.13528061 37.52531815 -26.31522942 34.45327759 37.52531815
		 -31.052742004 35.98602295 37.52531815 -36.61563873 38.41759109 37.52531815 -37.95272827 40.043434143 37.52531815
		 -38.38834381 40.99717331 37.52531815 -37.33799744 81.10819244 41.65439987 -38.46249008 38.16559982 39.6541481
		 -38.4822998 37.40914154 40.19524384 -38.49636078 36.87219238 41.65439987 -23.45404816 80.74462891 41.65439987
		 -24.5715313 38.069656372 41.65439987 -37.65445328 36.50460052 41.65439987 -28.97378731 33.69610596 41.65439987
		 -38.031272888 37.48274994 39.46837616 -37.53705215 44.73800659 31.67188835 1.47670603 44.73800659 31.67188835
		 1.55706501 44.73800659 32.7845192 0.48844099 44.73800659 36.65727615 -37.53705215 44.73800659 36.65727615
		 -37.53705215 60.24843597 36.65727615 -37.53705215 60.24843597 31.67188835 3.81856704 60.24843597 31.67188835
		 7.33530521 52.91355896 31.67188835 5.64722395 49.73153305 31.67188835 3.052920103 46.30720901 31.67188835
		 5.28985023 60.24843597 36.65727615 2.96507502 48.0070152283 36.65727615 7.26915598 56.12018967 36.65727615
		 -23.16739845 59.33200455 36.059028625 -23.16739845 73.22071075 36.059028625 -4.067192078 73.22071075 36.059028625
		 1.70894098 66.71631622 36.059028625 5.40435314 59.33200455 36.059028625 6.48679018 59.33200455 40.18811035
		 -23.16739845 59.33200455 40.18811035 -23.16739845 73.22071075 40.18811035 -1.980142 73.22071075 40.18811035
		 1.494277 69.30823517 40.18811035 -37.53705215 63.21327209 31.67188835 -7.87931824 63.21327209 31.67188835
		 -3.47687006 63.21327209 35.44466019 -2.86395311 63.21327209 36.65727615 -37.53705215 63.21327209 36.65727615
		 -37.53705215 78.72370148 36.65727615 -37.53705215 78.72370148 31.67188835 -12.52528954 78.72370148 31.67188835
		 -13.24973965 67.96916962 31.67188835 -11.012022018 78.72370148 36.65727615 -5.81727409 66.53895569 36.65727615
		 -11.75713444 71.79912567 36.65727615 -11.34818459 77.87004089 36.65727615 -11.43064785 78.72370148 36.092082977;
	setAttr -s 108 ".ed[0:107]"  0 1 0 1 2 0 2 3 0 3 4 0 4 0 0 5 6 0 6 0 0
		 4 5 0 6 7 0 7 8 0 8 9 0 9 10 0 10 11 0 11 1 0 12 5 0 3 13 0 13 14 0 14 12 0 12 15 0
		 15 7 0 13 10 0 9 14 0 8 15 0 2 11 0 16 17 0 17 18 0 18 19 0 19 20 0 20 21 0 21 22 0
		 22 23 0 23 16 0 24 16 0 23 25 0 25 26 0 26 27 0 27 24 0 24 28 0 28 17 0 28 29 0 29 18 0
		 27 30 0 30 31 0 31 29 0 31 19 0 30 32 1 32 20 1 32 21 1 26 32 0 32 22 1 25 32 1 33 34 0
		 34 35 0 35 36 0 36 37 0 37 33 0 38 39 0 39 33 0 37 38 0 39 40 0 40 41 0 41 42 0 42 43 0
		 43 34 0 44 38 0 36 45 0 45 46 0 46 44 0 44 40 0 45 42 0 41 46 0 35 43 0 47 48 0 48 49 0
		 49 50 0 50 51 0 51 47 0 52 53 0 53 47 0 51 52 0 53 54 0 54 48 0 54 55 0 55 49 0 52 56 0
		 56 55 0 50 56 0 57 58 0 58 59 0 59 60 0 60 61 0 61 57 0 62 63 0 63 57 0 61 62 0 63 64 0
		 64 65 0 65 58 0 66 62 0 60 67 0 67 68 0 68 69 0 69 66 0 66 70 0 70 64 0 59 67 0 65 68 0
		 70 69 0;
	setAttr -s 206 ".n";
	setAttr ".n[0:165]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1
		 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1
		 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.68423003 0.191192
		 -0.70375699 0.81623298 -0.048710998 -0.57566601 0.81623298 -0.048710998 -0.57566601
		 0.73301101 0.116885 -0.67009902 0.65216398 0.226716 -0.723382 0.65860999 0.226261
		 -0.71766198 0.68423003 0.191192 -0.70375699 0.73301101 0.116885 -0.67009902 0.65767902
		 0.226328 -0.71849501 0.56876898 -0.682908 -0.45840901 0.56876898 -0.682908 -0.45840901
		 0.588377 -0.68045098 -0.43680599 0.575023 -0.68219399 -0.451619 0.56876898 -0.682908
		 -0.45840901 0.65767902 0.226328 -0.71849501 0.62990803 0.228135 -0.74240798 0.65216398
		 0.226716 -0.723382 0.588377 -0.68045098 -0.43680599 0.71294397 -0.64608002 -0.27256399
		 0.575023 -0.68219399 -0.451619 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0
		 0 -1 -0.99965698 0.026177 0 -0.99965698 0.026177 0 -0.99965698 0.026177 0 -0.99965698
		 0.026177 0 -0.99965698 0.026177 0 -0.99965698 0.026177 0 0.026177 0.99965698 0 0.026177
		 0.99965698 0 0.026177 0.99965698 0 0.026177 0.99965698 0 0.99965698 -0.026177 0 0.99965698
		 -0.026177 0 0.99965698 -0.026177 0 0.99965698 -0.026177 0 0 0 1 0 0 1 0 0 1 0 0 1
		 0 0 1 0 0 1 -0.30825225 -0.91859031 -0.23566359 -0.31645089 -0.92076045 -0.20920855
		 -0.26742339 -0.93789929 -0.16751875 -0.24610525 -0.93225658 -0.23630719 -0.24610525
		 -0.93225658 -0.23630719 -0.29218763 -0.87122333 -0.37558672 -0.33456185 -0.85144269
		 -0.40387499 -0.33340192 -0.88528115 -0.31167603 -0.30825225 -0.91859031 -0.23566359
		 -0.31179574 -0.86697102 -0.37117982 -0.31542009 -0.86062449 -0.3890661 -0.33637571
		 -0.85076451 -0.40369615 -0.32145488 -0.86882687 -0.32324421 -0.33637571 -0.85076451
		 -0.40369615 -0.33824855 -0.85027957 -0.4028331 -0.32395685 -0.86933982 -0.31424749
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0 0
		 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0
		 1 0 0 1 0 0.84301901 -0.44722599 0.29884401 0.80764103 -0.53418201 0.249731 0.82775998
		 -0.48825601 0.27644101 0.84301901 -0.44722599 0.29884401 0.87138802 0.41779101 -0.25716299
		 0.87138802 0.41779101 -0.25716299 0.87138802 0.41779101 -0.257164 0.87138802 0.41779101
		 -0.257164 0.80764103 -0.53418201 0.249731 0.77847201 -0.58977902 0.214807 0.777493
		 -0.59333003 0.208481 0.77813298 -0.59103 0.212586 0.82775998 -0.48825601 0.27644101
		 0.777493 -0.59333003 0.208481 0.70461398 -0.70776302 -0.050889999 0.77813298 -0.59103
		 0.212586 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1
		 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0.77752799
		 0.55002201 -0.30483899 0.870664 0.435716 -0.22824501 0.870664 0.435716 -0.22824501
		 0.82813603 0.49312499 -0.26649299 0.82813603 0.49312499 -0.26649299 0.69943899 0.62112701
		 -0.353533 0.69943899 0.62112701 -0.353533 0.77752799 0.55002201 -0.30483899 0 -1
		 0 0 -1 0;
	setAttr ".n[166:205]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1
		 0 0 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1
		 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.52545601 0.59244299 -0.61066097 0.69943899
		 0.621126 -0.35353601 0.53509998 0.59517199 -0.59953201 0.53509998 0.59517199 -0.59953201
		 0.52437401 0.59213102 -0.611893 0.52437401 0.59213102 -0.611893 0.52437401 0.59213102
		 -0.611893 0.52545601 0.59244299 -0.61066097 0.96840203 -0.065734997 -0.240577 0.96860898
		 -0.065247998 -0.23987199 0.96860898 -0.065247998 -0.23987199 0.96860898 -0.065247998
		 -0.23987199 0.968256 -0.066074997 -0.241071 0.968256 -0.066074997 -0.241071 0.76613802
		 -0.30169699 -0.56746 0.96840203 -0.065734997 -0.240577;
	setAttr -s 47 -ch 216 ".fc[0:46]" -type "polyFaces" 
		f 5 0 1 2 3 4
		mu 0 5 0 1 2 3 4
		f 4 5 6 -5 7
		mu 0 4 5 6 7 8
		f 8 8 9 10 11 12 13 -1 -7
		mu 0 8 9 10 11 12 13 14 15 16
		f 6 14 -8 -4 15 16 17
		mu 0 6 17 18 19 20 21 22
		f 5 -6 -15 18 19 -9
		mu 0 5 23 24 25 26 27
		f 4 -17 20 -12 21
		mu 0 4 28 29 30 31
		f 5 -19 -18 -22 -11 22
		mu 0 5 32 33 28 31 34
		f 5 -16 -3 23 -13 -21
		mu 0 5 29 35 36 37 30
		f 3 -10 -20 -23
		mu 0 3 34 38 32
		f 3 -2 -14 -24
		mu 0 3 36 39 37
		f 8 24 25 26 27 28 29 30 31
		mu 0 8 40 41 42 43 44 45 46 47
		f 6 32 -32 33 34 35 36
		mu 0 6 48 49 50 51 52 53
		f 4 -33 37 38 -25
		mu 0 4 54 55 56 57
		f 4 -26 -39 39 40
		mu 0 4 58 59 60 61
		f 6 -38 -37 41 42 43 -40
		mu 0 6 62 63 64 65 66 67
		f 4 -27 -41 -44 44
		mu 0 4 68 69 70 71
		f 5 -43 45 46 -28 -45
		mu 0 5 71 72 73 74 68
		f 3 -29 -47 47
		mu 0 3 75 74 73
		f 4 -42 -36 48 -46
		mu 0 4 72 76 77 73
		f 3 -30 -48 49
		mu 0 3 78 75 73
		f 3 -35 50 -49
		mu 0 3 77 79 73
		f 4 -51 -34 -31 -50
		mu 0 4 73 79 80 78
		f 5 51 52 53 54 55
		mu 0 5 81 82 83 84 85
		f 4 56 57 -56 58
		mu 0 4 86 87 88 89
		f 7 59 60 61 62 63 -52 -58
		mu 0 7 90 91 92 93 94 95 96
		f 6 64 -59 -55 65 66 67
		mu 0 6 97 98 99 100 101 102
		f 4 -60 -57 -65 68
		mu 0 4 103 104 105 106
		f 4 -67 69 -62 70
		mu 0 4 107 108 109 110
		f 4 -61 -69 -68 -71
		mu 0 4 110 111 112 107
		f 5 -66 -54 71 -63 -70
		mu 0 5 108 113 114 115 109
		f 3 -53 -64 -72
		mu 0 3 114 116 115
		f 5 72 73 74 75 76
		mu 0 5 117 118 119 120 121
		f 4 77 78 -77 79
		mu 0 4 122 123 124 125
		f 4 -79 80 81 -73
		mu 0 4 126 127 128 129
		f 4 -74 -82 82 83
		mu 0 4 130 131 132 133
		f 5 -81 -78 84 85 -83
		mu 0 5 134 135 136 137 138
		f 4 -85 -80 -76 86
		mu 0 4 139 140 141 142
		f 4 -75 -84 -86 -87
		mu 0 4 142 143 144 139
		f 5 87 88 89 90 91
		mu 0 5 145 146 147 148 149
		f 4 92 93 -92 94
		mu 0 4 150 151 152 153
		f 5 95 96 97 -88 -94
		mu 0 5 154 155 156 157 158
		f 7 98 -95 -91 99 100 101 102
		mu 0 7 159 160 161 162 163 164 165
		f 5 -93 -99 103 104 -96
		mu 0 5 166 167 168 169 170
		f 3 -100 -90 105
		mu 0 3 171 172 173
		f 5 -89 -98 106 -101 -106
		mu 0 5 173 174 175 176 171
		f 5 -102 -107 -97 -105 107
		mu 0 5 177 176 175 178 179
		f 3 -104 -103 -108
		mu 0 3 179 180 177;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh3" -p "breakingcrate_geo";
	rename -uid "1A3A48B1-4512-8963-D53E-F99E1CCD9E9A";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" -13.207149505615234 23.346709251403809 36.663144111633301 ;
	setAttr ".sp" -type "double3" -13.207149505615234 23.346709251403809 36.663144111633301 ;
createNode mesh -n "breakingcrate_mesh3Shape" -p "breakingcrate_mesh3";
	rename -uid "0B3B3C6A-44BF-BB33-0FB7-A5AB37A85124";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh3ShapeOrig" -p "breakingcrate_mesh3";
	rename -uid "9247C0FC-4B8A-5BFE-F613-AA86FD5B0E12";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 123 ".uvst[0].uvsp[0:122]" -type "float2" 0.83689898 0.98205501
		 0.80858898 0.98205501 0.80858898 0.97030503 0.811158 0.97160298 0.81938702 0.97711599
		 0.82635999 0.97854102 0.83689898 0.96945399 0.97311997 0.50620401 0.96470398 0.50620401
		 0.96470398 0.49360299 0.96554703 0.493056 0.97311997 0.47539899 0.80537599 0.67048699
		 0.80537599 0.676337 0.77706498 0.676337 0.77706498 0.67048699 0.96470398 0.155349
		 0.96470398 0.14359801 0.97311997 0.14359801 0.97311997 0.1538 0.54139203 0.81309199
		 0.59046102 0.81309199 0.59046102 0.88991702 0.56772 0.83892202 0.56388998 0.82370299
		 0.56203997 0.82352102 0.54139203 0.83853298 0.68343836 -0.38998693 0.68345511 -0.39221269
		 0.68602139 -0.39167488 0.69609547 -0.37625852 0.69510317 -0.37204123 0.67883754 -0.37043718
		 0.67965335 -0.40141994 0.70014685 -0.38871443 0.66725796 -0.44388533 0.69417965 -0.430601
		 0.70148659 -0.40178084 0.69626206 -0.43021876 0.71852201 0.79057503 0.78587401 0.79057503
		 0.78632897 0.79568303 0.78706998 0.80073798 0.71852201 0.80073798 0.92082602 0.32018599
		 0.91066402 0.32018599 0.91066402 0.29821199 0.92082602 0.29821199 0.61344498 0.491855
		 0.66073501 0.491855 0.65911502 0.49946299 0.67309201 0.515019 0.67977202 0.51951599
		 0.68020803 0.52194798 0.68079698 0.523471 0.61344498 0.523471 0.127086 0.394503 0.127086
		 0.278698 0.181885 0.278698 0.181885 0.44964701 0.17836501 0.44787601 0.16316 0.45685399
		 0.14636201 0.41760099 0.128225 0.39415401 0.86112702 0.52589899 0.86112702 0.47534299
		 0.87063301 0.47534299 0.87063301 0.52498502 0.66139555 -0.35759717 0.66372705 -0.37282109
		 0.67928147 -0.37001336 0.67142648 -0.3264969 0.66328013 -0.37746346 0.67411131 -0.37746119
		 0.68976486 -0.35491174 0.69864911 -0.31316775 0.67740256 -0.2984187 0.68486738 -0.37767255
		 0.6852386 -0.37414867 0.68550944 -0.36888921 0.69758737 -0.29887801 0.67731082 -0.29718393
		 0.80258399 0.365762 0.82226002 0.365762 0.82226002 0.37417901 0.80258399 0.37417901
		 0.77929682 0.134592 0.850537 0.134592 0.850537 0.140441 0.78770792 0.140441 0.78661311
		 0.13837405 0.7850706 0.13760757 0.76805902 0.85622919 0.76805902 0.81309199 0.79636902
		 0.81309199 0.79636908 0.86260408 0.79543054 0.86126959 0.79261923 0.8590166 0.78115427
		 0.85577935 0.77141905 0.85378432 0.92267299 0.18947649 0.92267299 0.14359801 0.93108898
		 0.14359801 0.93108892 0.18673515 0.29821199 0.65629435 0.29821199 0.547396 0.34728199
		 0.547396 0.34728199 0.66181141 0.33213827 0.64595771 0.30121949 0.65507394 0.42493734
		 -0.48833266 0.42232704 -0.50167894 0.43849671 -0.50802875 0.43950057 -0.50289595
		 0.44516924 -0.48242497 0.44516921 -0.45082322 0.4353241 -0.45082322 0.44261512 -0.44826913
		 0.43637511 -0.44709212 0.452115 -0.45776901 0.44516921 -0.44821838 0.45426178 -0.45082322
		 0.45515552 -0.44814521;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 51 ".vt[0:50]"  -25.15168571 16.80956268 36.059028625 -25.15168571 30.69826889 36.059028625
		 -16.50881195 30.69826889 36.059028625 -17.46395302 29.43754005 36.059028625 -21.51864433 25.40089226 36.059028625
		 -22.56700134 21.97979736 36.059028625 -15.88279343 16.80956268 36.059028625 -25.15168571 16.80956268 40.18811035
		 -15.48035431 16.80956268 36.47269821 -2.49290895 16.80956268 40.18811035 -25.15168571 30.69826889 40.18811035
		 -17.64816475 30.69826889 40.18811035 -17.53339005 23.24610138 40.18811035 -22.022111893 24.33014297 40.18811035
		 -22.075880051 24.8539505 40.18811035 -22.2514286 24.41532135 39.61999512 -37.53705215 7.20095301 31.67188835
		 10.0053863525 7.20095301 31.67188835 10.32602119 7.20095301 34.17751312 10.84905434 7.20095301 36.65727615
		 -37.53705215 7.20095301 36.65727615 -37.53705215 22.71138573 36.65727615 -37.53705215 22.71138573 31.67188835
		 -4.15606213 22.71138573 31.67188835 -5.29974604 18.97921181 31.67188835 4.56673002 11.34749317 31.67188835
		 9.28161144 9.14164162 31.67188835 9.58971691 7.94857502 31.67188835 -4.75914001 22.71138573 36.65727615
		 10.34783459 8.19726563 36.65727615 12.8889122 12.50097561 36.65727615 1.77859294 17.25560951 36.65727615
		 -4.85794115 22.38896942 36.65727615 9.30692291 8.79924774 33.15799713 -39.30321121 6.059809208 37.52531815
		 -25.41926003 5.69624519 37.52531815 -25.41926003 5.69624519 41.65439987 -39.30321121 6.059809208 41.65439987
		 -38.38834381 40.99717331 37.52531815 -38.49636078 36.87219238 41.65439987 -38.4822998 37.40914154 40.19524384
		 -38.46249008 38.16559982 39.6541481 -24.62218475 36.13528061 37.52531815 -37.95272827 40.043434143 37.52531815
		 -36.61563873 38.41759109 37.52531815 -31.052742004 35.98602295 37.52531815 -26.31522942 34.45327759 37.52531815
		 -24.5715313 38.069656372 41.65439987 -28.97378731 33.69610596 41.65439987 -37.65445328 36.50460052 41.65439987
		 -38.031272888 37.48274994 39.46837616;
	setAttr -s 82 ".ed[0:81]"  0 1 0 1 2 0 2 3 0 3 4 0 4 5 0 5 6 0 6 0 0
		 7 0 0 6 8 0 8 9 0 9 7 0 7 10 0 10 1 0 10 11 0 11 2 0 9 12 0 12 13 0 13 14 0 14 11 0
		 13 15 0 15 14 0 15 3 0 12 15 0 15 4 0 8 15 0 15 5 0 16 17 0 17 18 0 18 19 0 19 20 0
		 20 16 0 21 22 0 22 16 0 20 21 0 22 23 0 23 24 0 24 25 0 25 26 0 26 27 0 27 17 0 28 21 0
		 19 29 0 29 30 0 30 31 0 31 32 0 32 28 0 28 23 0 29 33 0 33 30 0 33 31 0 18 33 0 33 25 0
		 24 32 0 27 33 0 33 26 0 34 35 0 35 36 0 36 37 0 37 34 0 38 34 0 37 39 0 39 40 0 40 41 0
		 41 38 0 42 35 0 38 43 0 43 44 0 44 45 0 45 46 0 46 42 0 47 36 0 42 47 0 47 48 0 48 49 0
		 49 39 0 46 48 0 45 50 1 50 49 1 50 40 0 44 50 1 50 41 1 43 50 1;
	setAttr -s 154 ".n[0:153]" -type "float3"  0 0 -1 0 0 -1 0 0 -1 0 0 -1
		 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0
		 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0.92796701 0.095252998
		 -0.360284 0.92796701 0.095252998 -0.360284 0.92796701 0.095252998 -0.360284 0.77524102
		 -0.60087401 0.194813 0.77847201 -0.58977902 0.214807 0.77847201 -0.58977902 0.214807
		 0.77847201 -0.58977902 0.214807 0.79967201 -0.579714 0.156385 0.234449 0.97079402
		 0.050912999 0.234449 0.97079402 0.050912999 0.234449 0.97079402 0.050912999 0.79868501
		 -0.60174501 -0.0021909999 0.77524102 -0.60087401 0.194813 0.79967201 -0.579714 0.156385
		 0.23137701 0.540667 -0.808792 0.23137701 0.540667 -0.808792 0.28134701 0.56993598
		 -0.772021 0.31885901 0.59061402 -0.74128598 0.94978398 -0.29104999 0.114895 0.79868501
		 -0.60174501 -0.0021909999 0.79967201 -0.579714 0.156385 0.28134701 0.56993598 -0.772021
		 0.52574599 0.67969799 -0.51147002 0.52574599 0.67969799 -0.51147002 0.31885901 0.59061402
		 -0.74128598 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1
		 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0
		 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0.81436801 -0.480836 -0.32496399 0.81436801
		 -0.480836 -0.32496399 0.81436801 -0.480836 -0.32496399 0.50652802 0.67364103 -0.53817898
		 0.23137701 0.540667 -0.808792 0.39629501 0.62940401 -0.66843098 0.87787902 0.44163799
		 -0.18516199 0.87787902 0.44163799 -0.18516199 0.87619102 0.45205101 -0.167152 0.88397598
		 0.449597 -0.128251 0.39629501 0.62940401 -0.66843098 0.52574599 0.67969799 -0.51147097
		 0.52574599 0.67969698 -0.51147097 0.52574599 0.67969698 -0.51147097 0.50652802 0.67364103
		 -0.53817898 0.88397598 0.449597 -0.128251 0.87619102 0.45205101 -0.167152 0.868581
		 0.48292199 -0.111149 0.88609099 0.454393 -0.091486998 0.415418 0.88793099 0.197502
		 0.415418 0.88793099 0.197502 0.415418 0.88793099 0.197502 0.94978398 -0.291051 0.114894
		 0.94978398 -0.291051 0.114894 0.94978398 -0.291051 0.114894 0.94978398 -0.291051
		 0.114894 0.88609099 0.454393 -0.091486998 0.967417 0.24983101 0.041083001 0.88397598
		 0.449597 -0.128251 -0.026177 -0.99965698 0 -0.026177 -0.99965698 0 -0.026177 -0.99965698
		 0 -0.026177 -0.99965698 0 -0.99965698 0.026177 0 -0.99965698 0.026177 0 -0.99965698
		 0.026177 0 -0.99965698 0.026177 0 -0.99965698 0.026177 0 -0.99965698 0.026177 0 0
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0.99965698 -0.026177 0 0.99965698
		 -0.026177 0 0.99965698 -0.026177 0 0.99965698 -0.026177 0 0 0 1 0 0 1 0 0 1 0 0 1
		 0 0 1 0 0 1 -0.24610525 -0.93225658 -0.23630719 -0.26742339 -0.93789929 -0.16751875
		 -0.31645089 -0.92076045 -0.20920855 -0.30825225 -0.91859031 -0.23566359 -0.30825225
		 -0.91859031 -0.23566359 -0.33340192 -0.88528115 -0.31167603 -0.33456185 -0.85144269
		 -0.40387499 -0.29218763 -0.87122333 -0.37558672 -0.24610525 -0.93225658 -0.23630719
		 -0.33637571 -0.85076451 -0.40369615 -0.31542009 -0.86062449 -0.3890661 -0.31179574
		 -0.86697102 -0.37117982 -0.33824855 -0.85027957 -0.4028331 -0.33637571 -0.85076451
		 -0.40369615 -0.32145488 -0.86882687 -0.32324421 -0.32395685 -0.86933982 -0.31424749;
	setAttr -s 37 -ch 164 ".fc[0:36]" -type "polyFaces" 
		f 7 0 1 2 3 4 5 6
		mu 0 7 0 1 2 3 4 5 6
		f 5 7 -7 8 9 10
		mu 0 5 7 8 9 10 11
		f 4 -8 11 12 -1
		mu 0 4 12 13 14 15
		f 4 -2 -13 13 14
		mu 0 4 16 17 18 19
		f 7 -12 -11 15 16 17 18 -14
		mu 0 7 20 21 22 23 24 25 26
		f 3 -18 19 20
		mu 0 3 27 28 29
		f 5 -3 -15 -19 -21 21
		mu 0 5 30 31 32 27 29
		f 3 -17 22 -20
		mu 0 3 28 33 29
		f 3 -4 -22 23
		mu 0 3 34 30 29
		f 4 -16 -10 24 -23
		mu 0 4 33 35 36 29
		f 3 -5 -24 25
		mu 0 3 37 34 29
		f 4 -9 -6 -26 -25
		mu 0 4 36 38 37 29
		f 5 26 27 28 29 30
		mu 0 5 39 40 41 42 43
		f 4 31 32 -31 33
		mu 0 4 44 45 46 47
		f 8 34 35 36 37 38 39 -27 -33
		mu 0 8 48 49 50 51 52 53 54 55
		f 8 40 -34 -30 41 42 43 44 45
		mu 0 8 56 57 58 59 60 61 62 63
		f 4 -35 -32 -41 46
		mu 0 4 64 65 66 67
		f 3 -43 47 48
		mu 0 3 68 69 70
		f 3 -44 -49 49
		mu 0 3 71 68 70
		f 4 -42 -29 50 -48
		mu 0 4 69 72 73 70
		f 5 51 -37 52 -45 -50
		mu 0 5 70 74 75 76 71
		f 4 -51 -28 -40 53
		mu 0 4 70 73 77 78
		f 3 -38 -52 54
		mu 0 3 79 74 70
		f 4 -36 -47 -46 -53
		mu 0 4 75 80 81 76
		f 3 -39 -55 -54
		mu 0 3 78 79 70
		f 4 55 56 57 58
		mu 0 4 82 83 84 85
		f 6 59 -59 60 61 62 63
		mu 0 6 86 87 88 89 90 91
		f 8 64 -56 -60 65 66 67 68 69
		mu 0 8 92 93 94 95 96 97 98 99
		f 4 70 -57 -65 71
		mu 0 4 100 101 102 103
		f 6 -61 -58 -71 72 73 74
		mu 0 6 104 105 106 107 108 109
		f 4 -73 -72 -70 75
		mu 0 4 110 111 112 113
		f 5 -69 76 77 -74 -76
		mu 0 5 113 114 115 116 110
		f 4 -62 -75 -78 78
		mu 0 4 117 118 116 115
		f 3 -68 79 -77
		mu 0 3 114 119 115
		f 3 -63 -79 80
		mu 0 3 120 117 115
		f 3 -67 81 -80
		mu 0 3 119 121 115
		f 4 -82 -66 -64 -81
		mu 0 4 115 121 122 120;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh4" -p "breakingcrate_geo";
	rename -uid "D9376B49-4D81-008D-4389-B188AA8F46B6";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" 7.9282169342041016 43.402218818664551 36.663144111633301 ;
	setAttr ".sp" -type "double3" 7.9282169342041016 43.402218818664551 36.663144111633301 ;
createNode mesh -n "breakingcrate_mesh4Shape" -p "breakingcrate_mesh4";
	rename -uid "C38BB4A7-48C4-0EAB-27D4-148292EE2E12";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh4ShapeOrig" -p "breakingcrate_mesh4";
	rename -uid "51140249-430F-A86D-A7FF-1D8E5D5F3687";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 246 ".uvst[0].uvsp[0:245]" -type "float2" 0.84702802 0.21415
		 0.84702802 0.233826 0.83861101 0.233826 0.83861101 0.21415 0.96470398 0.24056099
		 0.96470398 0.21415 0.97311997 0.21415 0.97311997 0.23902801 0.83560902 0.42210299
		 0.83560902 0.382274 0.86391902 0.382274 0.86391902 0.408685 0.848867 0.41391999 0.96861702
		 0.60593301 0.96861702 0.64280498 0.96020001 0.64280498 0.96020001 0.60297602 0.65801102
		 0.652165 0.65801102 0.71420699 0.60894102 0.71420699 0.60894102 0.62225097 0.62276399
		 0.63452703 0.60187119 -0.32246861 0.59924614 -0.35691297 0.58102691 -0.35748896 0.58457386
		 -0.31095412 0.58730739 -0.29112151 0.60641652 -0.28949741 0.364342 0.25317901 0.463312
		 0.25317901 0.463312 0.25978601 0.37527201 0.25978601 0.373936 0.25817901 0.66598397
		 0.34361601 0.66598397 0.27269399 0.69760001 0.27269399 0.69760001 0.33703399 0.68790501
		 0.34464201 0.986875 0.720981 0.976713 0.720981 0.976713 0.69900799 0.986875 0.69900799
		 0.127086 0.27523899 0.127086 0.103714 0.13010199 0.102526 0.15155099 0.101081 0.17013501
		 0.122067 0.181885 0.13250101 0.181885 0.27523899 0.81131798 0.26334101 0.74254 0.26334101
		 0.74254 0.25317901 0.81346202 0.25317901 0.81191099 0.262189 0.59842342 -0.37311202
		 0.59401655 -0.37661865 0.58660954 -0.36129814 0.57509536 -0.3353405 0.60212171 -0.3353405
		 0.61253196 -0.35880947 0.56065196 -0.31525809 0.56065196 -0.31099734 0.5765354 -0.29976434
		 0.5585767 -0.31281272 0.86713201 0.86770499 0.86713201 0.81309199 0.876638 0.81309199
		 0.876638 0.86920202 0.86925298 0.86758399 0.66752899 0.71852201 0.715298 0.71852201
		 0.715298 0.750139 0.66421199 0.750139 0.66644502 0.74694002 0.67012 0.73996001 0.67251098
		 0.73347402 0.88214302 0.77822101 0.88214302 0.76805902 0.90411597 0.76805902 0.90411597
		 0.77822101 0.068543002 0.54393703 0.068543002 0.43000701 0.083127998 0.43700001 0.111793
		 0.42179301 0.123342 0.41304299 0.123342 0.54393703 0.84611601 0.70019299 0.84611601
		 0.63445997 0.85317898 0.63445997 0.85317898 0.703192 0.65969098 -0.40250149 0.64444971
		 -0.40085658 0.64197642 -0.38989836 0.66029221 -0.38623482 0.66288257 -0.3977139 0.66441321
		 -0.40257043 0.63747245 -0.36077949 0.65852541 -0.37481427 0.63887626 -0.34161422
		 0.66101968 -0.34076262 0.78006798 0.64046502 0.80837798 0.64046502 0.80837798 0.64631402
		 0.78006798 0.64631402 0.79636902 0.48863 0.76805902 0.48863 0.76805902 0.382274 0.79636902
		 0.382274 0.928087 0.43609199 0.919671 0.43609199 0.919671 0.32973599 0.928087 0.32973599
		 0.45235899 0.812635 0.40329 0.812635 0.40329 0.547396 0.45235899 0.547396 0.91366601
		 0.47534299 0.92208302 0.47534299 0.92208302 0.58169901 0.91366601 0.58169901 0.78457099
		 0.77991301 0.78457099 0.77406299 0.81288099 0.77406299 0.81288099 0.77991301 0.870134
		 0.674335 0.870134 0.63445997 0.88029599 0.63445997 0.88029599 0.66989702 0.874394
		 0.67320299 0.67433602 0.75454903 0.71529698 0.75454903 0.71529698 0.786165 0.67542303
		 0.786165 0.67928302 0.78003597 0.68019098 0.778947 0.68022603 0.778108 0.67949098
		 0.775029 0.98667699 0.94969302 0.98667699 0.95985502 0.96470398 0.95985502 0.96470398
		 0.94969302 0.068543002 0.27523899 0.068543002 0.19294 0.092586003 0.20119999 0.112386
		 0.200018 0.123342 0.186864 0.123342 0.27523899 0.87963998 0.095926002 0.87963998
		 0.13120501 0.870134 0.13120501 0.870134 0.087415002 0.874147 0.091172002 0.53946966
		 -0.62099528 0.52515519 -0.62126154 0.52272916 -0.61192739 0.54703242 -0.61014414
		 0.54745001 -0.61175108 0.54890907 -0.62162209 0.52479464 -0.58914191 0.54718381 -0.60847014
		 0.53007048 -0.55893427 0.54513729 -0.55791312 0.54835492 -0.60176593 0.55633295 -0.55699342
		 0.63312101 0.53629798 0.61344498 0.53629798 0.61344498 0.52788198 0.63312101 0.52788198
		 0.96470398 0.49360299 0.96470398 0.439316 0.97311997 0.439316 0.97311997 0.47539899
		 0.96554703 0.493056 0.80858898 0.97030503 0.80858898 0.91516697 0.83689898 0.91516697
		 0.83689898 0.96945399 0.82635999 0.97854102 0.81938702 0.97711599 0.811158 0.97160298
		 0.97311997 0.1538 0.97311997 0.21048599 0.96470398 0.21048599 0.96470398 0.155349
		 0.59046102 0.88991702 0.59046102 0.97990298 0.54139203 0.97990298 0.54139203 0.83853298
		 0.56203997 0.82352102 0.56388998 0.82370299 0.56772 0.83892202 0.68057394 -0.33803707
		 0.68550164 -0.32938004 0.68811512 -0.32916868 0.69132149 -0.36881101 0.66294497 -0.37861013
		 0.68576443 -0.32716978 0.70218915 -0.3411364 0.69343549 -0.36869329 0.68365461 -0.30719697
		 0.69959009 -0.31083053 0.70004505 -0.31513911 0.70250052 -0.32800514 0.78587401 0.79057503
		 0.82487798 0.79057503 0.82487798 0.80073798 0.78706998 0.80073798 0.78632897 0.79568303
		 0.66073501 0.491855 0.71980101 0.491855 0.71980101 0.523471 0.68079698 0.523471 0.68020803
		 0.52194798 0.67977202 0.51951599 0.67309201 0.515019 0.65911502 0.49946299 0.976713
		 0.96320301 0.986875 0.96320301 0.986875 0.98517603 0.976713 0.98517603 0.127086 0.54393703
		 0.127086 0.394503 0.128225 0.39415401 0.14636201 0.41760099 0.16316 0.45685399 0.17836501
		 0.44787601 0.181885 0.44964701 0.181885 0.54393703 0.87063301 0.52498502 0.87063301
		 0.58904302 0.86112702 0.58904302 0.86112702 0.52589899 0.68868423 -0.43411341 0.67789167
		 -0.43502679 0.67794645 -0.43036321 0.69320953 -0.42625698 0.69949341 -0.42987648
		 0.69941992 -0.43341914 0.67434245 -0.41538951 0.69932085 -0.42461285 0.68172145 -0.38355556
		 0.70238525 -0.41032699 0.68531424 -0.3550742 0.70772624 -0.36798355 0.68511891 -0.35385147
		 0.70546615 -0.35383376;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 96 ".vt[0:95]"  24.047174454 59.33200455 36.059028625 24.047174454 73.22071075 36.059028625
		 24.047174454 73.22071075 40.18811035 24.047174454 59.33200455 40.18811035 5.40435314 59.33200455 36.059028625
		 6.48679018 59.33200455 40.18811035 -4.067192078 73.22071075 36.059028625 1.70894098 66.71631622 36.059028625
		 -1.980142 73.22071075 40.18811035 1.494277 69.30823517 40.18811035 -7.87931824 63.21327209 31.67188835
		 37.53705215 63.21327209 31.67188835 37.53705215 63.21327209 36.65727615 -2.86395311 63.21327209 36.65727615
		 -3.47687006 63.21327209 35.44466019 -12.52528954 78.72370148 31.67188835 37.53705215 78.72370148 31.67188835
		 -13.24973965 67.96916962 31.67188835 37.53705215 78.72370148 36.65727615 -11.012022018 78.72370148 36.65727615
		 -11.34818459 77.87004089 36.65727615 -11.75713444 71.79912567 36.65727615 -5.81727409 66.53895569 36.65727615
		 -11.43064785 78.72370148 36.092082977 1.47670603 44.73800659 31.67188835 37.53705215 44.73800659 31.67188835
		 37.53705215 44.73800659 36.65727615 0.48844099 44.73800659 36.65727615 1.55706501 44.73800659 32.7845192
		 3.81856704 60.24843597 31.67188835 37.53705215 60.24843597 31.67188835 3.052920103 46.30720901 31.67188835
		 5.64722395 49.73153305 31.67188835 7.33530521 52.91355896 31.67188835 37.53705215 60.24843597 36.65727615
		 5.28985023 60.24843597 36.65727615 7.26915598 56.12018967 36.65727615 2.96507502 48.0070152283 36.65727615
		 24.53948593 5.69624519 37.52531815 38.42343521 6.059809208 37.52531815 38.42343521 6.059809208 41.65439987
		 24.53948593 5.69624519 41.65439987 22.57427406 80.74462891 37.52531815 36.45822525 81.10819244 37.52531815
		 36.45822525 81.10819244 41.65439987 22.57427406 80.74462891 41.65439987 9.39053822 28.90206146 31.67188835
		 37.53705215 28.90206146 31.67188835 37.53705215 28.90206146 36.65727615 12.52313614 28.90206146 36.65727615
		 10.1895752 28.90206146 33.76191711 8.6233263 44.41249466 31.67188835 37.53705215 44.41249466 31.67188835
		 12.11553383 31.90907288 31.67188835 12.75653267 32.44293976 31.67188835 12.78110409 32.85467148 31.67188835
		 12.26221657 34.36507416 31.67188835 37.53705215 44.41249466 36.65727615 14.24287701 44.41249466 36.65727615
		 16.58078384 37.60721207 36.65727615 16.24633408 32.0029792786 36.65727615 11.1037693 44.41249466 33.77646255
		 24.047174454 16.80956268 36.059028625 24.047174454 30.69826889 36.059028625 24.047174454 30.69826889 40.18811035
		 24.047174454 16.80956268 40.18811035 -15.88279343 16.80956268 36.059028625 -2.49290895 16.80956268 40.18811035
		 -15.48035431 16.80956268 36.47269821 -16.50881195 30.69826889 36.059028625 -22.56700134 21.97979736 36.059028625
		 -21.51864433 25.40089226 36.059028625 -17.46395302 29.43754005 36.059028625 -17.64816475 30.69826889 40.18811035
		 -22.075880051 24.8539505 40.18811035 -22.022111893 24.33014297 40.18811035 -17.53339005 23.24610138 40.18811035
		 -22.2514286 24.41532135 39.61999512 10.0053863525 7.20095301 31.67188835 37.53705215 7.20095301 31.67188835
		 37.53705215 7.20095301 36.65727615 10.84905434 7.20095301 36.65727615 10.32602119 7.20095301 34.17751312
		 -4.15606213 22.71138573 31.67188835 37.53705215 22.71138573 31.67188835 9.58971691 7.94857502 31.67188835
		 9.28161144 9.14164162 31.67188835 4.56673002 11.34749317 31.67188835 -5.29974604 18.97921181 31.67188835
		 37.53705215 22.71138573 36.65727615 -4.75914001 22.71138573 36.65727615 -4.85794115 22.38896942 36.65727615
		 1.77859294 17.25560951 36.65727615 12.8889122 12.50097561 36.65727615 10.34783459 8.19726563 36.65727615
		 9.30692291 8.79924774 33.15799713;
	setAttr -s 148 ".ed[0:147]"  0 1 0 1 2 0 2 3 0 3 0 0 4 0 0 3 5 0 5 4 0
		 6 1 0 4 7 0 7 6 0 8 2 0 6 8 0 8 9 0 9 5 0 9 7 0 10 11 0 11 12 0 12 13 0 13 14 0 14 10 0
		 15 16 0 16 11 0 10 17 0 17 15 0 16 18 0 18 12 0 18 19 0 19 20 0 20 21 0 21 22 0 22 13 0
		 15 23 0 23 19 0 22 14 0 21 17 0 20 23 0 24 25 0 25 26 0 26 27 0 27 28 0 28 24 0 29 30 0
		 30 25 0 24 31 0 31 32 0 32 33 0 33 29 0 30 34 0 34 26 0 34 35 0 35 36 0 36 37 0 37 27 0
		 29 35 0 37 32 0 31 28 0 36 33 0 38 39 0 39 40 0 40 41 0 41 38 0 42 43 0 43 39 0 38 42 0
		 43 44 0 44 40 0 44 45 0 45 41 0 45 42 0 46 47 0 47 48 0 48 49 0 49 50 0 50 46 0 51 52 0
		 52 47 0 46 53 0 53 54 0 54 55 0 55 56 0 56 51 0 52 57 0 57 48 0 57 58 0 58 59 0 59 60 0
		 60 49 0 51 61 0 61 58 0 60 54 0 53 50 0 59 55 0 61 56 0 62 63 0 63 64 0 64 65 0 65 62 0
		 66 62 0 65 67 0 67 68 0 68 66 0 69 63 0 66 70 0 70 71 0 71 72 0 72 69 0 73 64 0 69 73 0
		 73 74 0 74 75 0 75 76 0 76 67 0 75 77 0 77 76 0 77 68 0 74 77 0 77 70 0 72 77 0 77 71 0
		 78 79 0 79 80 0 80 81 0 81 82 0 82 78 0 83 84 0 84 79 0 78 85 0 85 86 0 86 87 0 87 88 0
		 88 83 0 84 89 0 89 80 0 89 90 0 90 91 0 91 92 0 92 93 0 93 94 0 94 81 0 83 90 0 94 95 0
		 95 82 0 95 85 0 93 95 0 95 86 0 92 95 0 95 87 0 91 88 0;
	setAttr -s 296 ".n";
	setAttr ".n[0:165]" -type "float3"  1 0 0 1 0 0 1 0 0 1 0 0 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0
		 0 1 0 0 1 0 0 1 0 0 1 -0.82813603 -0.49312499 0.26649299 -0.870664 -0.435716 0.22824501
		 -0.870664 -0.435716 0.22824501 -0.77752799 -0.55002201 0.30483899 -0.77752799 -0.55002201
		 0.30483899 -0.69943899 -0.62112701 0.353533 -0.69943899 -0.62112701 0.353533 -0.82813603
		 -0.49312499 0.26649299 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0
		 0 -1 0 0 -1 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1
		 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.53509998 -0.59517199 0.59953201 -0.69943899 -0.621126
		 0.35353601 -0.52545702 -0.59244299 0.61066097 -0.52545702 -0.59244299 0.61066097
		 -0.52437401 -0.59213102 0.611893 -0.52437401 -0.59213102 0.611893 -0.52437401 -0.59213102
		 0.611893 -0.53509998 -0.59517199 0.59953201 -0.96860898 0.065247998 0.23987199 -0.96840203
		 0.065733999 0.240577 -0.968256 0.066074997 0.241071 -0.96860898 0.065247998 0.23987199
		 -0.96860898 0.065247998 0.23987199 -0.96840203 0.065733999 0.240577 -0.76613802 0.30169699
		 0.56746 -0.968256 0.066074997 0.241071 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1
		 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0
		 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 -0.777493 0.59333003 -0.208481 -0.77847201
		 0.58977902 -0.214807 -0.80764103 0.53418201 -0.249731 -0.82775998 0.48825601 -0.27644101
		 -0.77813298 0.59103 -0.212586 -0.77813298 0.59103 -0.212586 -0.70461398 0.70776302
		 0.050889999 -0.777493 0.59333003 -0.208481 -0.80764103 0.53418201 -0.249731 -0.84301901
		 0.44722599 -0.29884401 -0.84301901 0.44722599 -0.29884401 -0.82775998 0.48825601
		 -0.27644101 -0.87138802 -0.41779101 0.257164 -0.87138802 -0.41779101 0.257164 -0.87138802
		 -0.41779101 0.257164 -0.87138802 -0.41779101 0.257164 0.026177 -0.99965698 0 0.026177
		 -0.99965698 0 0.026177 -0.99965698 0 0.026177 -0.99965698 0 0 0 -1 0 0 -1 0 0 -1
		 0 0 -1 0.99965698 0.026177 0 0.99965698 0.026177 0 0.99965698 0.026177 0 0.99965698
		 0.026177 0 0 0 1 0 0 1 0 0 1 0 0 1 -0.99965698 -0.026177 0 -0.99965698 -0.026177
		 0 -0.99965698 -0.026177 0 -0.99965698 -0.026177 0 -0.026177 0.99965698 0 -0.026177
		 0.99965698 0 -0.026177 0.99965698 0 -0.026177 0.99965698 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0 1 0 0 1
		 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0;
	setAttr ".n[166:295]" -type "float3"  -0.588377 0.68045098 0.43680599 -0.56876898
		 0.682908 0.45840901 -0.56876898 0.682908 0.45840901 -0.56876898 0.682908 0.45840901
		 -0.575023 0.68219399 0.451619 -0.575023 0.68219399 0.451619 -0.71294397 0.64608002
		 0.27256399 -0.588377 0.68045098 0.43680599 -0.81623298 0.048710998 0.57566601 -0.68423098
		 -0.191192 0.70375699 -0.73301101 -0.116885 0.67009902 -0.81623298 0.048710998 0.57566601
		 -0.68423098 -0.191192 0.70375699 -0.658611 -0.226261 0.71766198 -0.65216398 -0.226716
		 0.723382 -0.65767902 -0.226328 0.718494 -0.73301101 -0.116885 0.67009902 -0.65216398
		 -0.226716 0.723382 -0.62990803 -0.228135 0.74240798 -0.65767902 -0.226328 0.718494
		 1 0 0 1 0 0 1 0 0 1 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0
		 0 1 0 0 1 -0.23445 -0.97079402 -0.050914001 -0.23445 -0.97079402 -0.050914001 -0.23445
		 -0.97079402 -0.050914001 -0.28134599 -0.56993598 0.772021 -0.23137701 -0.540667 0.808792
		 -0.23137701 -0.540667 0.808792 -0.31885901 -0.59061301 0.74128598 -0.927966 -0.095252998
		 0.36028501 -0.927966 -0.095252998 0.36028501 -0.927966 -0.095252998 0.36028501 -0.31885901
		 -0.59061301 0.74128598 -0.52574599 -0.67969698 0.51147097 -0.52574599 -0.67969698
		 0.51147097 -0.28134599 -0.56993598 0.772021 -0.79967201 0.579714 -0.156385 -0.77847201
		 0.58977902 -0.214807 -0.77847201 0.58977902 -0.214807 -0.77847201 0.58977902 -0.214807
		 -0.77524102 0.60087401 -0.194813 -0.79868501 0.60174501 0.0021899999 -0.94978398
		 0.29104999 -0.114894 -0.79967201 0.579714 -0.156385 -0.77524102 0.60087401 -0.194813
		 -0.79868501 0.60174501 0.0021899999 -0.79967201 0.579714 -0.156385 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0
		 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0
		 1 0 0 1 0 -0.87619102 -0.45205101 0.167152 -0.87787902 -0.44163799 0.18516199 -0.87787902
		 -0.44163799 0.18516199 -0.88397598 -0.449597 0.128251 -0.88609099 -0.454393 0.091486
		 -0.868581 -0.48292199 0.111149 -0.87619102 -0.45205101 0.167152 -0.88397598 -0.449597
		 0.128251 -0.81436801 0.48083499 0.32496399 -0.81436801 0.48083499 0.32496399 -0.81436801
		 0.48083499 0.32496399 -0.967417 -0.24983101 -0.041083001 -0.88609099 -0.454393 0.091486
		 -0.88397598 -0.449597 0.128251 -0.23137701 -0.540667 0.808792 -0.50652897 -0.67364103
		 0.53817898 -0.39629599 -0.62940401 0.66843098 -0.415418 -0.88793099 -0.197502 -0.415418
		 -0.88793099 -0.197502 -0.415418 -0.88793099 -0.197502 -0.50652897 -0.67364103 0.53817898
		 -0.52574599 -0.67969799 0.51147097 -0.52574599 -0.67969698 0.51147097 -0.52574599
		 -0.67969799 0.51147097 -0.39629599 -0.62940401 0.66843098 -0.94978398 0.291051 -0.114894
		 -0.94978398 0.291051 -0.114894 -0.94978398 0.291051 -0.114894 -0.94978398 0.291051
		 -0.114894;
	setAttr -s 66 -ch 296 ".fc[0:65]" -type "polyFaces" 
		f 4 0 1 2 3
		mu 0 4 0 1 2 3
		f 4 4 -4 5 6
		mu 0 4 4 5 6 7
		f 5 7 -1 -5 8 9
		mu 0 5 8 9 10 11 12
		f 4 10 -2 -8 11
		mu 0 4 13 14 15 16
		f 5 -6 -3 -11 12 13
		mu 0 5 17 18 19 20 21
		f 4 -9 -7 -14 14
		mu 0 4 22 23 24 25
		f 4 -13 -12 -10 -15
		mu 0 4 25 26 27 22
		f 5 15 16 17 18 19
		mu 0 5 28 29 30 31 32
		f 5 20 21 -16 22 23
		mu 0 5 33 34 35 36 37
		f 4 24 25 -17 -22
		mu 0 4 38 39 40 41
		f 7 26 27 28 29 30 -18 -26
		mu 0 7 42 43 44 45 46 47 48
		f 5 -27 -25 -21 31 32
		mu 0 5 49 50 51 52 53
		f 3 -19 -31 33
		mu 0 3 54 55 56
		f 5 -30 34 -23 -20 -34
		mu 0 5 56 57 58 59 54
		f 5 -29 35 -32 -24 -35
		mu 0 5 57 60 61 62 58
		f 3 -28 -33 -36
		mu 0 3 60 63 61
		f 5 36 37 38 39 40
		mu 0 5 64 65 66 67 68
		f 7 41 42 -37 43 44 45 46
		mu 0 7 69 70 71 72 73 74 75
		f 4 47 48 -38 -43
		mu 0 4 76 77 78 79
		f 6 49 50 51 52 -39 -49
		mu 0 6 80 81 82 83 84 85
		f 4 -50 -48 -42 53
		mu 0 4 86 87 88 89
		f 5 -40 -53 54 -45 55
		mu 0 5 90 91 92 93 94
		f 3 -44 -41 -56
		mu 0 3 94 95 90
		f 4 -52 56 -46 -55
		mu 0 4 92 96 97 93
		f 4 -51 -54 -47 -57
		mu 0 4 96 98 99 97
		f 4 57 58 59 60
		mu 0 4 100 101 102 103
		f 4 61 62 -58 63
		mu 0 4 104 105 106 107
		f 4 64 65 -59 -63
		mu 0 4 108 109 110 111
		f 4 66 67 -60 -66
		mu 0 4 112 113 114 115
		f 4 68 -64 -61 -68
		mu 0 4 116 117 118 119
		f 4 -69 -67 -65 -62
		mu 0 4 120 121 122 123
		f 5 69 70 71 72 73
		mu 0 5 124 125 126 127 128
		f 8 74 75 -70 76 77 78 79 80
		mu 0 8 129 130 131 132 133 134 135 136
		f 4 81 82 -71 -76
		mu 0 4 137 138 139 140
		f 6 83 84 85 86 -72 -83
		mu 0 6 141 142 143 144 145 146
		f 5 -84 -82 -75 87 88
		mu 0 5 147 148 149 150 151
		f 5 -73 -87 89 -78 90
		mu 0 5 152 153 154 155 156
		f 3 -77 -74 -91
		mu 0 3 156 157 152
		f 4 -86 91 -79 -90
		mu 0 4 154 158 159 155
		f 5 -85 -89 92 -80 -92
		mu 0 5 158 160 161 162 159
		f 3 -88 -81 -93
		mu 0 3 161 163 162
		f 4 93 94 95 96
		mu 0 4 164 165 166 167
		f 5 97 -97 98 99 100
		mu 0 5 168 169 170 171 172
		f 7 101 -94 -98 102 103 104 105
		mu 0 7 173 174 175 176 177 178 179
		f 4 106 -95 -102 107
		mu 0 4 180 181 182 183
		f 7 -99 -96 -107 108 109 110 111
		mu 0 7 184 185 186 187 188 189 190
		f 3 -111 112 113
		mu 0 3 191 192 193
		f 4 -100 -112 -114 114
		mu 0 4 194 195 191 193
		f 3 -110 115 -113
		mu 0 3 192 196 193
		f 4 116 -103 -101 -115
		mu 0 4 193 197 198 194
		f 5 -116 -109 -108 -106 117
		mu 0 5 193 196 199 200 201
		f 3 -104 -117 118
		mu 0 3 202 197 193
		f 3 -105 -119 -118
		mu 0 3 201 202 193
		f 5 119 120 121 122 123
		mu 0 5 203 204 205 206 207
		f 8 124 125 -120 126 127 128 129 130
		mu 0 8 208 209 210 211 212 213 214 215
		f 4 131 132 -121 -126
		mu 0 4 216 217 218 219
		f 8 133 134 135 136 137 138 -122 -133
		mu 0 8 220 221 222 223 224 225 226 227
		f 4 -134 -132 -125 139
		mu 0 4 228 229 230 231
		f 4 -123 -139 140 141
		mu 0 4 232 233 234 235
		f 4 -127 -124 -142 142
		mu 0 4 236 237 232 235
		f 3 -138 143 -141
		mu 0 3 234 238 235
		f 3 -128 -143 144
		mu 0 3 239 236 235
		f 3 -137 145 -144
		mu 0 3 238 240 235
		f 3 -129 -145 146
		mu 0 3 241 239 235
		f 5 -136 147 -130 -147 -146
		mu 0 5 240 242 243 241 235
		f 4 -135 -140 -131 -148
		mu 0 4 242 244 245 243;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh5" -p "breakingcrate_geo";
	rename -uid "A22A143A-46DD-84BF-8110-419EB84B3A18";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" 8.8519010543823242 82.218948364257813 -0.586517333984375 ;
	setAttr ".sp" -type "double3" 8.8519010543823242 82.218948364257813 -0.586517333984375 ;
createNode mesh -n "breakingcrate_mesh5Shape" -p "breakingcrate_mesh5";
	rename -uid "527168AB-4780-0FDD-C40F-C785A58DB576";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh5ShapeOrig" -p "breakingcrate_mesh5";
	rename -uid "0EBAF02C-4C2D-DA15-3249-FFAFE56CDA03";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 227 ".uvst[0].uvsp[0:226]" -type "float2" 0.73309398 0.14359801
		 0.73309398 0.20343401 0.72914797 0.212265 0.728715 0.212189 0.71059901 0.203596 0.71005797
		 0.20318399 0.70200998 0.211007 0.70200998 0.14359801 0.36532301 0.243108 0.33423901
		 0.243108 0.33423901 0.238168 0.36532301 0.238168 0.955697 0.122748 0.955697 0.053192001
		 0.959203 0.053286999 0.96280497 0.062912002 0.96280497 0.122748 0.93483597 0.53750497
		 0.93468201 0.43961099 0.93955898 0.439316 0.93971401 0.53753197 0.93580502 0.53307098
		 0.0099999998 0.928514 0.0099999998 0.87463701 0.177561 0.87463701 0.165849 0.87621897
		 0.150943 0.88687599 0.170302 0.90453303 0.181567 0.92103797 0.183465 0.928514 0.43111327
		 -0.49454179 0.40625447 -0.49454179 0.41759256 -0.48102164 0.41770515 -0.46786183
		 0.43260878 -0.46786183 0.43260878 -0.49454179 0.48885462 -0.49454179 0.46217465 -0.46786183
		 0.4903501 -0.46786183 0.4903501 -0.49454179 0.52525306 -0.47319886 0.52905011 -0.49454179
		 0.51991606 -0.46786183 0.5287903 -0.46786183 0.76762003 0.14359801 0.76762003 0.229131
		 0.76676798 0.22958601 0.76120502 0.22548801 0.75550902 0.22397199 0.74967003 0.20634601
		 0.74493802 0.18473101 0.738437 0.177793 0.73653603 0.181991 0.73653603 0.14359801
		 0.64452899 0.457766 0.61344498 0.457766 0.61344498 0.45282599 0.64452899 0.45282599
		 0.92867702 0.63445997 0.93256903 0.75375301 0.93210799 0.75274599 0.92867702 0.75752801
		 0.94382101 0.184462 0.94368798 0.143803 0.95070702 0.14359801 0.95083302 0.182475
		 0.949103 0.17840999 0.94624901 0.18214899 0.29504699 0.80985802 0.24117 0.80985802
		 0.24117 0.709723 0.251147 0.69419599 0.254917 0.68769097 0.25850201 0.69040197 0.27370399
		 0.622437 0.27648601 0.61810702 0.29324299 0.61016601 0.29504699 0.61019301 0.933617
		 0.63445997 0.933617 0.74965698 0.93352002 0.74999201 0.93279397 0.754246 0.32968652
		 -0.3652055 0.32541019 -0.36539775 0.32466185 -0.34036517 0.32968652 -0.3353405 0.35835278
		 -0.36400679 0.32444191 -0.33699131 0.32433444 -0.3353405 0.38742787 -0.3353405 0.38742787
		 -0.36275727 0.32968652 -0.32912642 0.37909752 -0.32701015 0.32441011 -0.33006412
		 0.41889921 -0.36161053 0.44516921 -0.3353405 0.32440323 -0.32935679 0.44516921 -0.36074209
		 0.38742787 -0.32666892 0.43478155 -0.32495284 0.47889131 -0.35935977 0.48712754 -0.3353405
		 0.48814493 -0.35010612 0.44516921 -0.32448572 0.48810858 -0.35890362 0.4564842 -0.32402551
		 0.48635149 -0.32280198 0.745103 0.547396 0.745103 0.65263897 0.714019 0.65263897
		 0.714019 0.547396 0.85362202 0.96470398 0.95886397 0.96470398 0.95886397 0.971811
		 0.85362202 0.971811 0.61344498 0.47084001 0.64452899 0.47084001 0.64452899 0.47578001
		 0.61344498 0.47578001 0.95613301 0.58942699 0.95613301 0.74085599 0.95119399 0.74085599
		 0.95119399 0.58942699 0.53644902 0.86456603 0.50536501 0.86456603 0.50536501 0.859626
		 0.53644902 0.859626 0.185629 0.27616599 0.23950399 0.27569601 0.24179401 0.53814799
		 0.18792 0.53861803 0.83816397 0.547396 0.83816397 0.60302001 0.81609398 0.59985602
		 0.81609398 0.547396 0.96020001 0.87029999 0.96020001 0.81751698 0.96730798 0.81467599
		 0.96730798 0.87029999 0.53043699 0.78050399 0.508367 0.78050399 0.508367 0.77556401
		 0.53043699 0.77556401 0.56691098 0.547396 0.60516298 0.547396 0.60516298 0.67114002
		 0.56691098 0.67902899 0.94386297 0.49296999 0.95089 0.49564201 0.95105398 0.54588699
		 0.94403601 0.54609102 0.40315574 -0.6162377 0.46198952 -0.6162371 0.45983291 -0.59493923
		 0.40099967 -0.59493977 0.80425102 0.94971597 0.75635201 0.94971597 0.76126897 0.94677103
		 0.76216298 0.94498301 0.75356698 0.92267299 0.80425102 0.92267299 0.53388602 0.79435903
		 0.53388602 0.77556401 0.54099399 0.77556401 0.54099399 0.79435903 0.94479102 0.69180399
		 0.94479102 0.739703 0.937684 0.739703 0.937684 0.684241 0.93468201 0.21334 0.93468201
		 0.14359801 0.93962097 0.14359801 0.93962097 0.216524 0.27569601 0.97254801 0.27569601
		 0.92567497 0.396575 0.92567497 0.38296801 0.950221 0.39262801 0.96364498 0.41401201
		 0.97254801 0.47371471 -0.40681276 0.44723159 -0.40681276 0.4676016 -0.42718273 0.47371471
		 -0.42718273 0.48894399 -0.42718273 0.50027168 -0.40681276 0.41758955 -0.40681276
		 0.42090386 -0.42718273 0.73009199 0.81309199 0.73009199 0.86381102 0.72974497 0.86394799
		 0.72739601 0.86407 0.71553499 0.85051298 0.71415198 0.84886903 0.69900799 0.84190297
		 0.69900799 0.81309199 0.547396 0.531946 0.547396 0.500862 0.55233598 0.500862 0.55233598
		 0.531946 0.85388702 0.94068599 0.90255201 0.94692701 0.90450603 0.95262402 0.90495199
		 0.95425802 0.85362202 0.94767499 0.91774797 0.617948 0.94685501 0.617948 0.94685501
		 0.62505603 0.91804498 0.62505603 0.0099999998 0.98555601 0.0099999998 0.93167901
		 0.082592003 0.93167901 0.092845 0.94717199 0.110612 0.95755601 0.131082 0.97000402
		 0.129921 0.98555601 0.41175082 -0.40618774 0.38178307 -0.40618774 0.38134825 -0.42655772
		 0.43212026 -0.42655772 0.43823391 -0.42655772 0.43823391 -0.40618774 0.48986158 -0.42655772
		 0.46949217 -0.40618774 0.49597523 -0.42198348 0.49285027 -0.40618774 0.49597523 -0.42655772
		 0.49670628 -0.42655772;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 91 ".vt[0:90]"  37.73060226 78.75595856 36.80390549 -4.50600815 78.75595856 36.80390549
		 -10.73955727 78.75595856 34.86801147 -10.68565559 78.75595856 34.65571976 -4.61992121 78.75595856 25.76799965
		 -4.32910919 78.75595856 25.50275993 -9.85165119 78.75595856 21.5544796 37.73060226 78.75595856 21.5544796
		 37.73060226 82.24280548 21.5544796 37.73060226 82.24280548 36.80390549 -11.3674612 82.24280548 36.80390549
		 -11.30019569 80.52297211 36.80390549 -9.69629478 82.24280548 21.5544796 -7.57637215 81.54532623 21.5544796
		 -6.38134623 82.24280548 22.0020999908 -2.16223311 82.24280548 25.018508911 -7.64176798 82.24280548 30.016178131
		 -10.83023453 82.24280548 34.68802643 38.98457718 78.38273621 21.26692581 -21.37027931 78.45167542 19.68798447
		 -21.67995262 78.47026062 19.26232529 -18.71692657 78.58595276 16.61245155 -17.57398605 78.70658112 13.84965038
		 -5.061467171 78.817276 11.31431007 10.25146675 78.90109253 9.3944912 15.23044872 79.034561157 6.33757305
		 12.29288387 79.078620911 5.3285079 39.38375473 79.047676086 6.037231922 39.38375473 82.53120422 6.18932581
		 38.98457718 81.86626434 21.4190197 -19.51883888 81.19384766 19.8562355 -19.02507782 80.86811829 19.85495567
		 11.050835609 82.56356812 5.44810915 15.1602354 79.92783356 5.44074202 12.61313248 81.35318756 5.43621206
		 6.58355904 82.44545746 8.15326309 4.7151022 82.40102386 9.17099857 5.45557404 82.35590363 10.2044239
		 -13.88754177 82.19025421 13.99846458 -15.1331377 82.15731049 14.75296211 -17.50436211 81.95307159 19.43088531
		 -17.50988007 81.93079376 19.94106865 -17.67449188 81.86252594 19.93377304 -19.76037979 81.35318756 19.85686111
		 -18.95035172 81.35318756 19.37251282 -16.75468445 81.35318756 13.88272381 6.13962603 81.35318756 9.22850418
		 19.89008522 82.5683136 -39.38415527 19.89008522 86.055160522 -39.38415527 35.13428879 82.5683136 -38.96301651
		 35.13428879 86.055160522 -38.96301651 17.94544983 82.5683136 37.78997803 17.94544983 86.055160522 37.78997803
		 33.18965149 82.5683136 38.21112061 33.18965149 86.055160522 38.21112061 37.73060226 78.75595856 -6.73320913
		 37.73060226 82.24280548 -6.73320913 37.73060226 78.75595856 4.093883991 37.73060226 82.24280548 4.093883991
		 -1.53275299 78.75595856 4.093883991 0.70036697 78.75595856 -6.73320913 0.472664 82.24280548 4.093883991
		 2.70578408 82.24280548 -6.73320913 38.37359238 78.75595856 -8.20717239 4.56422091 78.75595856 -7.91212177
		 8.0222826 78.75595856 -9.38728237 8.64575481 78.75595856 -10.26989269 2.48314404 78.75595856 -21.16146851
		 38.25782013 78.75595856 -21.47366905 38.25782013 82.24280548 -21.47366905 38.37359238 82.24280548 -8.20717239
		 -0.774185 82.24280548 -7.86553478 4.045114994 82.24280548 -21.17510033 7.95697308 82.24280548 -14.26142216
		 5.25610018 82.24280548 -10.43796825 37.73060226 78.75595856 -22.14099503 1.92891395 78.75595856 -22.14099503
		 1.83242905 78.75595856 -22.31151962 1.74639904 78.75595856 -23.46362114 11.31582737 78.75595856 -29.28253365
		 12.4766922 78.75595856 -29.96102524 17.39370346 78.75595856 -37.39042282 37.73060226 78.75595856 -37.39042282
		 37.73060226 82.24280548 -37.39042282 37.73060226 82.24280548 -22.14099503 3.78783393 82.24280548 -22.14099503
		 2.28137302 79.53890228 -22.14099503 17.18405914 82.24280548 -37.39042282 14.2818327 82.24280548 -33.005279541
		 9.25298595 82.24280548 -30.066068649 3.45912504 82.24280548 -26.54297829;
	setAttr -s 141 ".ed[0:140]"  0 1 0 1 2 0 2 3 0 3 4 0 4 5 0 5 6 0 6 7 0
		 7 0 0 8 9 0 9 0 0 7 8 0 9 10 0 10 11 0 11 1 0 12 8 0 6 13 0 13 12 0 12 14 0 14 15 0
		 15 16 0 16 17 0 17 10 0 11 2 0 17 3 0 16 4 0 15 5 0 14 13 0 18 19 0 19 20 0 20 21 0
		 21 22 0 22 23 0 23 24 0 24 25 0 25 26 0 26 27 0 27 18 0 28 29 0 29 18 0 27 28 0 18 30 0
		 30 31 0 31 19 0 32 28 0 26 33 0 33 34 0 34 32 0 32 35 0 35 36 0 36 37 0 37 38 0 38 39 0
		 39 40 0 40 41 0 41 29 0 41 42 0 42 43 0 43 30 0 31 44 0 44 20 0 44 21 0 43 44 0 45 22 0
		 44 40 0 39 45 0 42 44 0 45 46 0 46 23 0 46 24 0 37 46 0 45 38 0 46 34 0 33 25 0 36 46 0
		 46 35 0 51 47 0 47 49 0 49 53 0 53 51 0 52 48 0 48 47 0 51 52 0 48 50 0 50 49 0 50 54 0
		 54 53 0 54 52 0 57 59 0 59 60 0 60 55 0 55 57 0 58 61 0 61 59 0 57 58 0 56 58 0 55 56 0
		 56 62 0 62 61 0 60 62 0 63 64 0 64 65 0 65 66 0 66 67 0 67 68 0 68 63 0 69 70 0 70 63 0
		 68 69 0 70 71 0 71 64 0 72 69 0 67 72 0 72 73 0 73 74 0 74 71 0 73 66 0 65 74 0 75 76 0
		 76 77 0 77 78 0 78 79 0 79 80 0 80 81 0 81 82 0 82 75 0 83 84 0 84 75 0 82 83 0 84 85 0
		 85 86 0 86 76 0 87 83 0 81 87 0 87 88 0 88 89 0 89 90 0 90 85 0 80 88 0 79 89 0 78 90 0
		 77 86 0;
	setAttr -s 282 ".n";
	setAttr ".n[0:165]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.19554301
		 -0.75186801 0.62964898 -0.19554301 -0.75186801 0.62964898 -0.19554301 -0.75186801
		 0.62964898 -0.96855003 -0.037881002 -0.24591701 -0.96855003 -0.037881002 -0.24591701
		 -0.858307 -0.030843001 -0.51220798 -0.85668498 -0.030750999 -0.51492202 -0.96855003
		 -0.037881002 -0.24591701 -0.71374899 0.199439 -0.67140597 -0.85668498 -0.030750999
		 -0.51492202 -0.858307 -0.030843001 -0.51220798 -0.81217402 0.0068870001 -0.58337402
		 -0.81217402 0.0068870001 -0.58337402 -0.64252502 0.30145499 -0.704476 -0.64252502
		 0.30145499 -0.704476 -0.71374899 0.199439 -0.67140597 -0.52545899 0.428615 0.73497099
		 -0.52545899 0.428615 0.73497099 -0.52545899 0.428615 0.73497099 -0.52545899 0.428615
		 0.73497099 -0.52545899 0.428615 0.73497099 -0.123956 -0.37675101 0.917983 -0.123956
		 -0.37675101 0.917983 -0.123956 -0.37675101 0.917983 0 -0.99904799 -0.043618999 0
		 -0.99904799 -0.043618999 0 -0.99904799 -0.043618999 0 -0.99904799 -0.043618999 0
		 -0.99904799 -0.043618999 0 -0.99904799 -0.043618999 0 -0.99904799 -0.043618999 0
		 -0.99904799 -0.043618999 0 -0.99904799 -0.043618999 0 -0.99904799 -0.043618999 0.99965698
		 -0.001142 0.026152 0.99965698 -0.001142 0.026152 0.99965698 -0.001142 0.026152 0.99965698
		 -0.001142 0.026152 -0.026177 -0.043604001 0.99870598 -0.026177 -0.043604001 0.99870598
		 -0.026177 -0.043604001 0.99870598 -0.026177 -0.043604001 0.99870598 0.026177 0.043605
		 -0.99870598 0.026177 0.043605 -0.99870598 0.026177 0.043605 -0.99870598 0.026177
		 0.043605 -0.99870598 0.026177 0.043605 -0.99870598 0.026177 0.043605 -0.99870598
		 0 0.99904799 0.043618999 0 0.99904799 0.043618999 0 0.99904799 0.043618999 0 0.99904799
		 0.043618999 0 0.99904799 0.043618999 0 0.99904799 0.043618999 0 0.99904799 0.043618999
		 0 0.99904799 0.043618999 0 0.99904799 0.043618999 0 0.99904799 0.043618999 -0.026177
		 -0.043604001 0.99870598 -0.026177 -0.043604001 0.99870598 -0.026177 -0.043604001
		 0.99870598 -0.026177 -0.043604001 0.99870598 -0.026177 -0.043604001 0.99870598 -0.026177
		 -0.043604001 0.99870598 -0.64137501 0.588449 0.49230701 -0.64137501 0.588449 0.49230701
		 -0.64137501 0.588449 0.49230701 -0.64137399 0.588449 0.49230701 -0.71692902 0.60952097
		 -0.338375 -0.56508201 0.55824703 -0.60748798 -0.70146698 0.62169099 -0.34848899 -0.40571901
		 -0.61235499 -0.67853802 -0.40571901 -0.61235499 -0.67853802 -0.40571901 -0.61235499
		 -0.67853802 -0.40571901 -0.61235499 -0.67853802 -0.65754998 0.64500803 -0.38934901
		 -0.73420799 0.61213499 -0.29365 -0.71692902 0.60952097 -0.338375 -0.70146698 0.62169099
		 -0.34848899 0 0.99904799 0.043618999 0 0.99904799 0.043618999 -0.209885 0.91254801
		 -0.35100499 -0.362019 0.93189299 -0.022741999 -0.70146698 0.62169099 -0.34848899
		 -0.196541 0.063336998 -0.97844797 -0.19867501 0.073716 -0.97728902 -0.19867501 0.073716
		 -0.97728902 -0.134197 -0.20473599 -0.96957397 -0.362019 0.93189299 -0.022741999 0
		 0.99904799 0.043618999 0 0.99904799 0.043618999 -0.70146698 0.62169099 -0.34848899
		 -0.118577 -0.26363999 -0.95730603 -0.196541 0.063336998 -0.97844797 -0.134197 -0.20473599
		 -0.96957397 0 0.99904799 0.043618999 -0.15421 0.63309002 -0.75856203 -0.15421 0.63309002
		 -0.75856203 -0.65754998 0.64500803 -0.38934901 0 0.99904799 0.043618999 0 0.99904799
		 0.043618999 -0.65754998 0.64500803 -0.38934901 -0.37459001 -0.67142302 -0.63943303
		 -0.37459001 -0.67142302 -0.63943303 -0.39136699 -0.62752801 -0.67308301 -0.38071799
		 -0.65779299 -0.649894 -0.37459001 -0.67142302 -0.63943303 -0.56031698 -0.74148899
		 0.36910501 -0.56031698 -0.74148899 0.36910501 -0.56031698 -0.74148899 0.36910501
		 -0.228839 0.68069601 0.69590598 -0.228839 0.68069601 0.69590598 -0.228839 0.68069601
		 0.69590598 -0.42245099 -0.54283702 -0.72585398 -0.424977 -0.54140902 -0.72544599
		 -0.38071799 -0.65779299 -0.649894 -0.39136699 -0.62752801 -0.67308301 -0.38484699
		 -0.56331998 -0.73113799 -0.42245099 -0.54283702 -0.72585398 -0.39136699 -0.62752801
		 -0.67308301 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -0.99968302 0 -0.025189999 -0.99968302 0
		 -0.025189999 -0.99968302 0 -0.025189999 -0.99968302 0 -0.025189999 0.027616 0 -0.99961901
		 0.027616 0 -0.99961901 0.027616 0 -0.99961901 0.027616 0 -0.99961901 0.99968302 0
		 0.025189999 0.99968302 0 0.025189999 0.99968302 0 0.025189999 0.99968302 0 0.025189999;
	setAttr ".n[166:281]" -type "float3"  -0.027616 0 0.99961901 -0.027616 0 0.99961901
		 -0.027616 0 0.99961901 -0.027616 0 0.99961901 0 1 0 0 1 0 0 1 0 0 1 0 0 -1 0 0 -1
		 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0
		 0 1 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 -0.85332298 0.490778 -0.176 -0.85332298 0.490778
		 -0.176 -0.85332298 0.490778 -0.176 -0.85332298 0.490778 -0.176 0 -1 0 0 -1 0 0 -1
		 0 0 -1 0 0 -1 0 0 -1 0 0.99996197 0 -0.0087259999 0.99996197 0 -0.0087259999 0.99996197
		 0 -0.0087259999 0.99996197 0 -0.0087259999 0.0087270001 0 0.99996197 0.0087270001
		 0 0.99996197 0.0087270001 0 0.99996197 0.0087270001 0 0.99996197 -0.0087270001 0
		 -0.99996197 -0.0087270001 0 -0.99996197 -0.0087270001 0 -0.99996197 -0.0087270001
		 0 -0.99996197 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.43609199 -0.558568 -0.70556802
		 -0.63102001 -0.63491797 -0.44575 -0.63102001 -0.63491797 -0.44574901 -0.49824101
		 -0.58742702 -0.63771898 -0.49824101 -0.58742702 -0.63771898 -0.33817199 -0.50715297
		 -0.79273897 -0.33817199 -0.50715297 -0.79273897 -0.43609199 -0.558568 -0.70556802
		 -0.81036001 0.364802 0.458514 -0.81036001 0.364802 0.458514 -0.81036001 0.364802
		 0.458514 -0.81036103 0.364802 0.458514 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 -1 0 0 -1
		 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.83285999 -0.050074998
		 -0.55121398 -0.83285999 -0.050074998 -0.55121398 -0.83285999 -0.050074998 -0.55121398
		 -0.83285999 -0.050074998 -0.55121398 -0.45267501 -0.44184601 -0.77450502 -0.46021
		 -0.44490701 -0.768287 -0.462356 -0.44577301 -0.76649499 -0.45267501 -0.44184601 -0.77450502
		 -0.46021 -0.44490701 -0.768287 -0.46482399 -0.446767 -0.76441997 -0.46482399 -0.446767
		 -0.76441997 -0.462356 -0.44577301 -0.76649499 -0.871723 0.48562899 0.065300003 -0.87171501
		 0.48567 0.065094002 -0.87171501 0.48567 0.065094002 -0.87171501 0.48567 0.065094002
		 -0.87177998 0.485302 0.066949002 -0.87177998 0.485302 0.066949002 -0.810368 0.36480701
		 0.458496 -0.871723 0.48562899 0.065300003;
	setAttr -s 62 -ch 282 ".fc[0:61]" -type "polyFaces" 
		f 8 0 1 2 3 4 5 6 7
		mu 0 8 0 1 2 3 4 5 6 7
		f 4 8 9 -8 10
		mu 0 4 8 9 10 11
		f 5 11 12 13 -1 -10
		mu 0 5 12 13 14 15 16
		f 5 14 -11 -7 15 16
		mu 0 5 17 18 19 20 21
		f 8 -9 -15 17 18 19 20 21 -12
		mu 0 8 22 23 24 25 26 27 28 29
		f 3 -2 -14 22
		mu 0 3 30 31 32
		f 5 -13 -22 23 -3 -23
		mu 0 5 32 33 34 35 30
		f 4 -4 -24 -21 24
		mu 0 4 36 35 34 37
		f 4 -20 25 -5 -25
		mu 0 4 37 38 39 36
		f 5 -16 -6 -26 -19 26
		mu 0 5 40 41 39 38 42
		f 3 -18 -17 -27
		mu 0 3 42 43 40
		f 10 27 28 29 30 31 32 33 34 35 36
		mu 0 10 44 45 46 47 48 49 50 51 52 53
		f 4 37 38 -37 39
		mu 0 4 54 55 56 57
		f 4 40 41 42 -28
		mu 0 4 58 59 60 61
		f 6 43 -40 -36 44 45 46
		mu 0 6 62 63 64 65 66 67
		f 10 -38 -44 47 48 49 50 51 52 53 54
		mu 0 10 68 69 70 71 72 73 74 75 76 77
		f 6 -55 55 56 57 -41 -39
		mu 0 6 78 79 80 81 59 58
		f 4 -29 -43 58 59
		mu 0 4 82 83 84 85
		f 3 -30 -60 60
		mu 0 3 86 82 85
		f 4 -42 -58 61 -59
		mu 0 4 84 87 88 85
		f 6 62 -31 -61 63 -53 64
		mu 0 6 89 90 86 85 91 92
		f 3 -57 65 -62
		mu 0 3 88 93 85
		f 4 -32 -63 66 67
		mu 0 4 94 90 89 95
		f 4 -56 -54 -64 -66
		mu 0 4 93 96 91 85
		f 3 -33 -68 68
		mu 0 3 97 94 95
		f 4 -51 69 -67 70
		mu 0 4 98 99 95 89
		f 3 -52 -71 -65
		mu 0 3 92 98 89
		f 5 -34 -69 71 -46 72
		mu 0 5 100 97 95 101 102
		f 3 -50 73 -70
		mu 0 3 99 103 95
		f 3 -45 -35 -73
		mu 0 3 102 104 100
		f 4 -48 -47 -72 74
		mu 0 4 105 106 101 95
		f 3 -49 -75 -74
		mu 0 3 103 105 95
		f 4 75 76 77 78
		mu 0 4 107 108 109 110
		f 4 79 80 -76 81
		mu 0 4 111 112 113 114
		f 4 82 83 -77 -81
		mu 0 4 115 116 117 118
		f 4 84 85 -78 -84
		mu 0 4 119 120 121 122
		f 4 86 -82 -79 -86
		mu 0 4 123 124 125 126
		f 4 -87 -85 -83 -80
		mu 0 4 127 128 129 130
		f 4 87 88 89 90
		mu 0 4 131 132 133 134
		f 4 91 92 -88 93
		mu 0 4 135 136 137 138
		f 4 94 -94 -91 95
		mu 0 4 139 140 141 142
		f 4 -95 96 97 -92
		mu 0 4 143 144 145 146
		f 4 98 -97 -96 -90
		mu 0 4 147 148 149 150
		f 4 -89 -93 -98 -99
		mu 0 4 151 152 153 154
		f 6 99 100 101 102 103 104
		mu 0 6 155 156 157 158 159 160
		f 4 105 106 -105 107
		mu 0 4 161 162 163 164
		f 4 -100 -107 108 109
		mu 0 4 165 166 167 168
		f 4 110 -108 -104 111
		mu 0 4 169 170 171 172
		f 6 -106 -111 112 113 114 -109
		mu 0 6 173 174 175 176 177 178
		f 4 -114 115 -102 116
		mu 0 4 179 180 181 182
		f 4 -101 -110 -115 -117
		mu 0 4 182 183 184 179
		f 4 -113 -112 -103 -116
		mu 0 4 180 185 186 181
		f 8 117 118 119 120 121 122 123 124
		mu 0 8 187 188 189 190 191 192 193 194
		f 4 125 126 -125 127
		mu 0 4 195 196 197 198
		f 5 128 129 130 -118 -127
		mu 0 5 199 200 201 202 203
		f 4 131 -128 -124 132
		mu 0 4 204 205 206 207
		f 7 -126 -132 133 134 135 136 -129
		mu 0 7 208 209 210 211 212 213 214
		f 4 -134 -133 -123 137
		mu 0 4 215 216 217 218
		f 4 -122 138 -135 -138
		mu 0 4 218 219 220 215
		f 4 -121 139 -136 -139
		mu 0 4 219 221 222 220
		f 5 -130 -137 -140 -120 140
		mu 0 5 223 224 222 221 225
		f 3 -119 -131 -141
		mu 0 3 225 226 223;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh6" -p "breakingcrate_geo";
	rename -uid "F891D455-49F8-4FB3-DB3E-E682D628DCB4";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" 37.029716491699219 43.402213335037231 12.228683948516846 ;
	setAttr ".sp" -type "double3" 37.029716491699219 43.402213335037231 12.228683948516846 ;
createNode mesh -n "breakingcrate_mesh6Shape" -p "breakingcrate_mesh6";
	rename -uid "678040A6-47C7-CD39-5EA0-C8BFAFB1983D";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh6ShapeOrig" -p "breakingcrate_mesh6";
	rename -uid "9FFCBB8F-4118-743F-CD75-289F7BB48BE7";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 246 ".uvst[0].uvsp[0:245]" -type "float2" 0.880642 0.439358
		 0.880642 0.37591699 0.88117301 0.37559 0.88942599 0.37669101 0.89014798 0.37597099
		 0.89014798 0.439358 0.947846 0.32018599 0.937684 0.32018599 0.937684 0.29821199 0.947846
		 0.29821199 0.78006798 0.63730001 0.78006798 0.576801 0.788504 0.57675397 0.80127102
		 0.58048999 0.81168401 0.57795697 0.81168401 0.63730001 0.358257 0.167749 0.358257
		 0.0099999998 0.41305599 0.0099999998 0.41305599 0.157867 0.40345001 0.16800299 0.40322399
		 0.168008 0.402329 0.168106 0.89380598 0.173004 0.89380598 0.233502 0.88364398 0.233502
		 0.88364398 0.170248 0.50554669 -0.33759806 0.50553566 -0.33786315 0.50575018 -0.33756483
		 0.50558048 -0.33652541 0.50642961 -0.35240802 0.50826764 -0.35298374 0.52926576 -0.30487204
		 0.53005409 -0.2879065 0.50795728 -0.28539279 0.52627057 -0.35232493 0.52938491 -0.33370596
		 0.5275591 -0.35259137 0.86391902 0.87998003 0.83560902 0.87998003 0.83560902 0.83514601
		 0.83613902 0.83501703 0.85556901 0.85153699 0.85564399 0.85166502 0.856134 0.85137999
		 0.86391902 0.84811699 0.97371 0.31975099 0.97371 0.284702 0.98212701 0.284702 0.98212701
		 0.31656501 0.75320899 0.52788198 0.75320899 0.53629798 0.73353302 0.53629798 0.73353302
		 0.52788198 0.96320301 0.87463701 0.97161901 0.87463701 0.97161901 0.91974503 0.96654302
		 0.92050099 0.96569401 0.919761 0.96408898 0.91994798 0.96320301 0.91947198 0.646469
		 0.81309199 0.69553798 0.81309199 0.69553798 0.90049899 0.68723601 0.89549297 0.65899998
		 0.92528701 0.646469 0.92558599 0.48349446 -0.39308187 0.48109126 -0.40078226 0.49900496
		 -0.40657717 0.50291055 -0.39406058 0.50291055 -0.39308187 0.48779041 -0.35046065
		 0.50291055 -0.3381837 0.50101781 -0.33723328 0.5031727 -0.39334399 0.49076697 -0.33608076
		 0.50317734 -0.39308187 0.50783187 -0.34026182 0.50616372 -0.33859366 0.50807899 -0.33932698
		 0.87963998 0.189629 0.87963998 0.239711 0.870134 0.239711 0.870134 0.18204901 0.299714
		 0.131667 0.299714 0.0099999998 0.35451299 0.0099999998 0.35451299 0.126831 0.34619901
		 0.134895 0.33580399 0.153431 0.86112702 0.470494 0.86112702 0.46033201 0.88310099
		 0.46033201 0.88310099 0.470494 0.72302598 0.491855 0.763502 0.491855 0.77943403 0.51921999
		 0.77960002 0.51961398 0.77951902 0.51967901 0.776963 0.523471 0.72302598 0.523471
		 0.870134 0.250177 0.88029599 0.250177 0.88029599 0.29896399 0.87658399 0.29755801
		 0.870134 0.290654 0.472682 -0.42709461 0.47477943 -0.43928656 0.49270275 -0.43150365
		 0.49104467 -0.42186308 0.46857366 -0.40918887 0.4910005 -0.42167026 0.47774532 -0.37442431
		 0.46944675 -0.37413129 0.49101675 -0.42100644 0.49412119 -0.37843746 0.88414299 0.53817803
		 0.88414299 0.57145399 0.87463701 0.57145399 0.87463701 0.53006399 0.41679999 0.109753
		 0.41679999 0.0099999998 0.47159901 0.0099999998 0.47159901 0.087626003 0.45114899
		 0.090226002 0.42861 0.105272 0.93433601 0.32018599 0.92417401 0.32018599 0.92417401
		 0.29821199 0.93433601 0.29821199 0.78457099 0.770899 0.78457099 0.72530001 0.788665
		 0.72806001 0.79129398 0.72875398 0.79456598 0.730272 0.81618702 0.73218203 0.81618702
		 0.770899 0.89022303 0.90845102 0.880642 0.90845102 0.880642 0.86602497 0.88514501
		 0.86407101 0.89022303 0.86008602 0.4761076 -0.50856459 0.47195485 -0.53952026 0.49512067
		 -0.51635444 0.49616522 -0.50856459 0.48797807 -0.49363208 0.47856507 -0.49353796
		 0.49711335 -0.50276732 0.46727258 -0.56372774 0.48653975 -0.56071657 0.49824333 -0.4922682
		 0.86391902 0.076888002 0.83560902 0.076888002 0.83560902 0.041845001 0.83997798 0.043871999
		 0.85604799 0.045292001 0.86391902 0.046459999 0.96170199 0.37932301 0.96170199 0.35525501
		 0.97011799 0.35525501 0.97011799 0.38568199 0.70517403 0.52788198 0.70517403 0.53629798
		 0.685498 0.53629798 0.685498 0.52788198 0.98362797 0.90648198 0.98362797 0.94152498
		 0.97521102 0.94152498 0.97521198 0.90971297 0.66148001 0.547396 0.710549 0.547396
		 0.710549 0.60742098 0.69479901 0.61078399 0.68315399 0.61226398 0.66148001 0.62673199
		 0.45628846 -0.56630594 0.45279455 -0.58542866 0.46873748 -0.58287019 0.47176373 -0.56630594
		 0.45895496 -0.55252016 0.47814184 -0.53333384 0.47953686 -0.52293289 0.46294835 -0.52275336
		 0.88364398 0.76381898 0.88364398 0.68195403 0.88910002 0.68492198 0.89070702 0.68614501
		 0.89070702 0.76381898 0.92082602 0.27515301 0.91066402 0.27515301 0.91066402 0.25317901
		 0.92082602 0.25317901 0.799582 0.099904001 0.799582 0.037115999 0.80997002 0.038550001
		 0.82215399 0.040635999 0.83119798 0.043008 0.83119798 0.099904001 0.35368401 0.81609398
		 0.50140703 0.81609398 0.50140703 0.870893 0.366779 0.870893 0.357788 0.83439398 0.35449201
		 0.81779999 0.89322501 0.112863 0.88364398 0.112863 0.88364398 0.050035998 0.88443297
		 0.049908001 0.89322501 0.046266999 0.46152791 -0.56630594 0.45353076 -0.61103928
		 0.45809519 -0.6111213 0.47702801 -0.59218848 0.48165539 -0.56630594 0.46522972 -0.54624546
		 0.48567188 -0.54453915 0.46726277 -0.54421234 0.47376332 -0.61212081 0.46557155 -0.54401892
		 0.82789302 0.91201001 0.799582 0.91201001 0.799582 0.90616101 0.82789302 0.90616101
		 0.781358 0.78735101 0.753048 0.78735101 0.753048 0.68099499 0.781358 0.68099499 0.91607797
		 0.43609199 0.90766197 0.43609199 0.90766197 0.32973599 0.91607797 0.32973599 0.50940102
		 0.53793299 0.46033201 0.53793299 0.46033201 0.27269399 0.50940102 0.27269399 0.91908097
		 0.249954 0.91066402 0.249954 0.91066402 0.14359801 0.91908097 0.14359801 0.85061997
		 0.35525501 0.85903603 0.35525501 0.85903603 0.37492999 0.85061997 0.37492999;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 96 ".vt[0:95]"  32.11177444 63.21327209 31.25766182 32.11177444 63.21327209 -10.63098812
		 32.39062119 63.21327209 -10.84681416 36.71852493 63.21327209 -10.12014675 37.097164154 63.21327209 -10.59526062
		 37.097164154 63.21327209 31.25766182 37.097164154 78.72370148 31.25766182 32.11177444 78.72370148 31.25766182
		 32.11177444 78.72370148 -11.44700527 32.11177444 74.58473969 -11.48052311 32.11177444 68.3217392 -8.84364033
		 37.097164154 78.72370148 -13.39224529 37.097164154 65.93198395 -13.4640379 37.097164154 65.99609375 -13.46556282
		 37.097164154 66.24925995 -13.49326611 37.048229218 66.0016784668 -13.47617722 35.76576996 59.33200455 23.60728645
		 35.76576996 73.22071075 23.60728645 35.76576996 73.22071075 -8.039920807 35.76576996 72.96040344 -8.13099861
		 35.76576996 63.42866898 3.53030205 35.76576996 63.39143753 3.62067389 35.76576996 63.15145493 3.41963792
		 35.76576996 59.33200455 1.11633003 39.89485168 59.33200455 -1.132635 39.89485168 59.33200455 23.60728645
		 39.89485168 73.22071075 23.60728645 39.89485168 73.22071075 -8.23316765 37.40453339 73.22071075 -8.76659584
		 36.98822403 73.22071075 -8.24421406 36.2005806 73.22071075 -8.37646198 39.89485168 61.68180084 0.284403
		 39.89485168 69.6738739 -8.14881229 35.82969666 63.42266846 3.54837394 37.097164154 44.73800659 -1.81065595
		 37.097164154 44.73800659 31.25766182 32.11177444 44.73800659 31.25766182 32.11177444 44.73800659 -6.81516314
		 37.097164154 60.24843597 -3.17958999 37.097164154 60.24843597 31.25766182 37.097164154 47.091053009 -4.093195915
		 37.097164154 50.033306122 -9.33979416 32.11177444 60.24843597 31.25766182 32.11177444 60.24843597 2.68602109
		 32.11177444 46.82366943 -8.55999184 32.11177444 46.63034058 -8.67657757 32.11177444 46.59863663 -8.6200428
		 35.27607346 60.24843597 -2.18770695 37.097164154 28.90206146 9.2860651 37.097164154 28.90206146 31.25766182
		 32.11177444 28.90206146 31.25766182 32.11177444 28.90206146 3.92868996 37.097164154 44.41249466 3.023189068
		 37.097164154 44.41249466 31.25766182 37.097164154 34.69012833 8.55025005 37.097164154 41.069633484 4.29164791
		 32.11177444 44.41249466 31.25766182 32.11177444 44.41249466 -0.92911899 32.11177444 42.40394974 1.019242048
		 32.11177444 41.11434937 1.50858498 32.11177444 39.50891876 2.58028007 34.75370789 44.41249466 1.72294497
		 35.76576996 16.80956268 23.60728645 35.76576996 30.69826889 23.60728645 35.76576996 30.69826889 -1.12857997
		 35.76576996 28.55485916 0.302241 35.76576996 20.67120552 1.30446005 35.76576996 16.80956268 2.12907791
		 39.89485168 16.80956268 6.61778593 39.89485168 16.80956268 23.60728645 39.89485168 30.69826889 23.60728645
		 39.89485168 30.69826889 1.15173197 39.89485168 21.2675724 5.66581917 39.89485168 24.56375885 5.24678802
		 32.11177444 7.20095301 31.25766182 32.11177444 7.20095301 -8.90396118 35.96302414 7.20095301 -7.44779491
		 37.097164154 7.20095301 -6.84786606 37.097164154 7.20095301 31.25766182 37.097164154 22.71138573 31.25766182
		 32.11177444 22.71138573 31.25766182 32.11177444 22.71138573 -13.062693596 32.11177444 17.61496925 -12.050363541
		 32.11177444 11.63774872 -10.57794952 37.097164154 22.71138573 -10.55417633 37.097164154 17.53162766 -9.39270115
		 37.097164154 22.22848511 -10.32566357 36.68648911 22.71138573 -10.63914871 37.81857681 5.74968576 36.64040756
		 37.81857681 5.99207687 22.75381851 41.94765854 5.99207687 22.75381851 41.94765854 5.74968576 36.64040756
		 37.81857681 80.81235504 37.950634 37.81857681 81.054740906 24.064043045 41.94765854 81.054740906 24.064043045
		 41.94765854 80.81235504 37.950634;
	setAttr -s 147 ".ed[0:146]"  0 1 0 1 2 0 2 3 0 3 4 0 4 5 0 5 0 0 6 7 0
		 7 0 0 5 6 0 7 8 0 8 9 0 9 10 0 10 1 0 11 6 0 4 12 0 12 13 0 13 14 0 14 11 0 11 8 0
		 12 15 0 15 13 0 15 14 0 3 15 0 15 9 0 2 15 0 15 10 0 16 17 0 17 18 0 18 19 0 19 20 0
		 20 21 0 21 22 0 22 23 0 23 16 0 24 25 0 25 16 0 23 24 0 25 26 0 26 17 0 26 27 0 27 28 0
		 28 29 0 29 30 0 30 18 0 24 31 0 31 32 0 32 27 0 22 33 0 33 31 0 33 29 0 28 32 0 21 33 0
		 33 20 0 19 30 0 34 35 0 35 36 0 36 37 0 37 34 0 38 39 0 39 35 0 34 40 0 40 41 0 41 38 0
		 39 42 0 42 36 0 42 43 0 43 44 0 44 45 0 45 46 0 46 37 0 38 47 0 47 43 0 46 40 0 45 41 0
		 44 47 0 48 49 0 49 50 0 50 51 0 51 48 0 52 53 0 53 49 0 48 54 0 54 55 0 55 52 0 53 56 0
		 56 50 0 56 57 0 57 58 0 58 59 0 59 60 0 60 51 0 52 61 0 61 57 0 54 60 0 59 55 0 58 61 0
		 62 63 0 63 64 0 64 65 0 65 66 0 66 67 0 67 62 0 68 69 0 69 62 0 67 68 0 69 70 0 70 63 0
		 70 71 0 71 64 0 68 72 0 72 73 0 73 71 0 66 72 0 65 73 0 74 75 0 75 76 0 76 77 0 77 78 0
		 78 74 0 79 80 0 80 74 0 78 79 0 80 81 0 81 82 0 82 83 0 83 75 0 84 79 0 77 85 0 85 86 0
		 86 84 0 84 87 0 87 81 0 76 83 0 82 85 0 87 86 0 88 89 0 89 90 0 90 91 0 91 88 0 92 93 0
		 93 89 0 88 92 0 93 94 0 94 90 0 94 95 0 95 91 0 95 92 0;
	setAttr -s 294 ".n";
	setAttr ".n[0:165]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0
		 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0.20163199 -0.087606996 -0.97553599
		 0.209415 -0.023269 -0.97755003 0.200498 -0.096412003 -0.97493899 0.199165 -0.106594
		 -0.97415203 0.20163199 -0.087606996 -0.97553599 0.200498 -0.096412003 -0.97493899
		 -0.6534 -0.54946703 -0.520724 -0.6534 -0.54946703 -0.520724 -0.6534 -0.54946703 -0.520724
		 -0.6534 -0.54946703 -0.520724 -0.36348701 0.0075440002 -0.93156898 -0.36348701 0.0075440002
		 -0.93156898 -0.36348701 0.0075440002 -0.93156898 -0.36348701 0.0075440002 -0.93156898
		 -0.36348701 0.0075440002 -0.93156898 0.105665 -0.76992702 -0.62932301 0.105665 -0.76992702
		 -0.62932301 0.105665 -0.76992702 -0.62932301 -0.72324198 -0.26797599 -0.63648301
		 -0.72324198 -0.26797599 -0.63648301 -0.72324198 -0.26797599 -0.63648301 -0.58991098
		 0.26666501 -0.76216501 -0.58991098 0.26666501 -0.76216501 -0.58991098 0.26666501
		 -0.76216501 -0.58991098 0.26666501 -0.76216501 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0
		 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 -0.42269999
		 0.468009 -0.77607501 -0.42269999 0.468009 -0.77607501 -0.42269999 0.468009 -0.77607501
		 -0.422739 0.46800801 -0.77605402 -0.423125 0.46800199 -0.77584797 -0.65340102 -0.54946703
		 -0.520724 -0.65340102 -0.54946703 -0.520724 -0.65340102 -0.54946703 -0.520724 -0.65340102
		 -0.54946703 -0.520724 -0.65340102 -0.54946703 -0.520724 -0.422739 0.46800801 -0.77605402
		 -0.763089 0.41503599 -0.495419 -0.423125 0.46800199 -0.77584797 0.20939399 -0.023250001
		 -0.97755498 0.20939399 -0.023250001 -0.97755498 0.20939399 -0.023250001 -0.97755498
		 0.105641 -0.76997602 -0.62926698 0.105645 -0.76996601 -0.629278 0.105663 -0.769925
		 -0.62932599 0.105663 -0.769925 -0.62932599 0.105663 -0.769925 -0.62932599 0.020891
		 -0.92439401 -0.38086599 0.105645 -0.76996601 -0.629278 0.105641 -0.76997602 -0.62926698
		 -0.58991802 0.266666 -0.76215899 -0.58991802 0.266666 -0.76215899 -0.58991802 0.266666
		 -0.76215899 0 -1 0 0 -1 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1
		 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0
		 1 0 0 1 0 0 1 0 0.55214298 -0.63620698 -0.53886801 0.58458799 -0.564906 -0.58235598
		 0.58458799 -0.564906 -0.58235598 0.51476002 -0.70322198 -0.49040899 0.468494 -0.77056903
		 -0.43213001 0.55214298 -0.63620698 -0.53886801 0.51476002 -0.70322198 -0.49040899
		 0.468494 -0.77056903 -0.43213001 -0.60953301 0.45260999 -0.65085602 -0.42269999 0.46801001
		 -0.77607399 -0.42269999 0.46801001 -0.77607399 -0.42269999 0.46801001 -0.77607399
		 -0.45685199 0.46704 -0.75707299 -0.45685199 0.46704 -0.75707299 -0.76308203 0.41502899
		 -0.49543601 -0.60953301 0.45260999 -0.65085602 0 -1 0 0 -1 0 0 -1 0 0 -1 0 1 0 0
		 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0;
	setAttr ".n[166:293]" -type "float3"  -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0
		 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.43337199 -0.445382 -0.78346902 0.417395 -0.504529 -0.755799
		 0.417395 -0.504529 -0.755799 0.43973699 -0.41891301 -0.79444498 0.472996 -0.336932
		 -0.81409597 0.46047899 -0.31492001 -0.82993001 0.43337199 -0.445382 -0.78346902 0.43973699
		 -0.41891301 -0.79444498 0.48258501 -0.35410801 -0.80107403 0.72933501 -0.086278997
		 -0.67869401 0.72933501 -0.086278997 -0.67869401 0.72933501 -0.086278997 -0.67869502
		 0.72933501 -0.086278997 -0.67869401 0.48258501 -0.35410801 -0.80107403 0.584589 -0.56490499
		 -0.58235598 0.472996 -0.336932 -0.81409597 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1
		 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1
		 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0.72922301 -0.111152 -0.675188 0.72840202 -0.14308199
		 -0.670044 0.72840202 -0.14308199 -0.670044 0.72923499 -0.11031 -0.675313 0.72933501
		 -0.086280003 -0.67869401 0.72922301 -0.111152 -0.675188 0.72923499 -0.11031 -0.675313
		 0.72933501 -0.086280003 -0.67869401 0.417395 -0.504529 -0.755799 0.417395 -0.504529
		 -0.755799 0.417395 -0.504529 -0.755799 0.417395 -0.504529 -0.755799 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1
		 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.45837599
		 -0.199402 -0.86610001 0.45687801 -0.21276399 -0.86370897 0.44987801 -0.22013 -0.86553597
		 0.45103201 -0.21892001 -0.865242 0.458675 -0.19664 -0.86657399 0.460843 -0.17314
		 -0.87042898 0.45837599 -0.199402 -0.86610001 0.458675 -0.19664 -0.86657399 0.461086
		 -0.172883 -0.87035102 0.460751 -0.173237 -0.87045801 0.44987801 -0.22013 -0.86553597
		 0.333507 -0.33279601 -0.88205498 0.45103201 -0.21892001 -0.865242 0.460751 -0.173237
		 -0.87045801 0.183841 -0.42044899 -0.88849598 0.460843 -0.17314 -0.87042898 0 -0.99984801
		 -0.017452 0 -0.99984801 -0.017452 0 -0.99984801 -0.017452 0 -0.99984801 -0.017452
		 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0.017452 -0.99984801 0 0.017452 -0.99984801 0 0.017452
		 -0.99984801 0 0.017452 -0.99984801 1 0 0 1 0 0 1 0 0 1 0 0 0 -0.017452 0.99984801
		 0 -0.017452 0.99984801 0 -0.017452 0.99984801 0 -0.017452 0.99984801 0 0.99984801
		 0.017452 0 0.99984801 0.017452 0 0.99984801 0.017452 0 0.99984801 0.017452;
	setAttr -s 65 -ch 294 ".fc[0:64]" -type "polyFaces" 
		f 6 0 1 2 3 4 5
		mu 0 6 0 1 2 3 4 5
		f 4 6 7 -6 8
		mu 0 4 6 7 8 9
		f 6 9 10 11 12 -1 -8
		mu 0 6 10 11 12 13 14 15
		f 7 13 -9 -5 14 15 16 17
		mu 0 7 16 17 18 19 20 21 22
		f 4 -10 -7 -14 18
		mu 0 4 23 24 25 26
		f 3 -16 19 20
		mu 0 3 27 28 29
		f 3 -17 -21 21
		mu 0 3 30 27 29
		f 4 -15 -4 22 -20
		mu 0 4 28 31 32 29
		f 5 -11 -19 -18 -22 23
		mu 0 5 33 34 35 30 29
		f 3 -3 24 -23
		mu 0 3 32 36 29
		f 3 -12 -24 25
		mu 0 3 37 33 29
		f 4 -2 -13 -26 -25
		mu 0 4 36 38 37 29
		f 8 26 27 28 29 30 31 32 33
		mu 0 8 39 40 41 42 43 44 45 46
		f 4 34 35 -34 36
		mu 0 4 47 48 49 50
		f 4 -36 37 38 -27
		mu 0 4 51 52 53 54
		f 7 -39 39 40 41 42 43 -28
		mu 0 7 55 56 57 58 59 60 61
		f 6 -38 -35 44 45 46 -40
		mu 0 6 62 63 64 65 66 67
		f 5 -45 -37 -33 47 48
		mu 0 5 68 69 70 71 72
		f 5 -46 -49 49 -42 50
		mu 0 5 73 68 72 74 75
		f 3 -32 51 -48
		mu 0 3 71 76 72
		f 3 -41 -47 -51
		mu 0 3 75 77 73
		f 5 52 -30 53 -43 -50
		mu 0 5 72 78 79 80 74
		f 3 -31 -53 -52
		mu 0 3 76 78 72
		f 3 -29 -44 -54
		mu 0 3 79 81 80
		f 4 54 55 56 57
		mu 0 4 82 83 84 85
		f 6 58 59 -55 60 61 62
		mu 0 6 86 87 88 89 90 91
		f 4 63 64 -56 -60
		mu 0 4 92 93 94 95
		f 7 65 66 67 68 69 -57 -65
		mu 0 7 96 97 98 99 100 101 102
		f 5 -64 -59 70 71 -66
		mu 0 5 103 104 105 106 107
		f 4 -61 -58 -70 72
		mu 0 4 108 109 110 111
		f 4 -62 -73 -69 73
		mu 0 4 112 108 111 113
		f 5 -71 -63 -74 -68 74
		mu 0 5 114 115 112 113 116
		f 3 -67 -72 -75
		mu 0 3 116 117 114
		f 4 75 76 77 78
		mu 0 4 118 119 120 121
		f 6 79 80 -76 81 82 83
		mu 0 6 122 123 124 125 126 127
		f 4 84 85 -77 -81
		mu 0 4 128 129 130 131
		f 7 86 87 88 89 90 -78 -86
		mu 0 7 132 133 134 135 136 137 138
		f 5 -85 -80 91 92 -87
		mu 0 5 139 140 141 142 143
		f 4 -83 93 -90 94
		mu 0 4 144 145 146 147
		f 5 -92 -84 -95 -89 95
		mu 0 5 148 149 144 147 150
		f 4 -82 -79 -91 -94
		mu 0 4 145 151 152 146
		f 3 -88 -93 -96
		mu 0 3 150 153 148
		f 6 96 97 98 99 100 101
		mu 0 6 154 155 156 157 158 159
		f 4 102 103 -102 104
		mu 0 4 160 161 162 163
		f 4 -104 105 106 -97
		mu 0 4 164 165 166 167
		f 4 -98 -107 107 108
		mu 0 4 168 169 170 171
		f 6 -106 -103 109 110 111 -108
		mu 0 6 172 173 174 175 176 177
		f 4 -110 -105 -101 112
		mu 0 4 178 179 180 181
		f 4 -111 -113 -100 113
		mu 0 4 182 178 181 183
		f 4 -99 -109 -112 -114
		mu 0 4 183 184 185 182
		f 5 114 115 116 117 118
		mu 0 5 186 187 188 189 190
		f 4 119 120 -119 121
		mu 0 4 191 192 193 194
		f 6 122 123 124 125 -115 -121
		mu 0 6 195 196 197 198 199 200
		f 6 126 -122 -118 127 128 129
		mu 0 6 201 202 203 204 205 206
		f 5 -120 -127 130 131 -123
		mu 0 5 207 208 209 210 211
		f 5 -128 -117 132 -125 133
		mu 0 5 212 213 214 215 216
		f 5 -129 -134 -124 -132 134
		mu 0 5 217 212 216 218 219
		f 3 -116 -126 -133
		mu 0 3 214 220 215
		f 3 -131 -130 -135
		mu 0 3 219 221 217
		f 4 135 136 137 138
		mu 0 4 222 223 224 225
		f 4 139 140 -136 141
		mu 0 4 226 227 228 229
		f 4 142 143 -137 -141
		mu 0 4 230 231 232 233
		f 4 144 145 -138 -144
		mu 0 4 234 235 236 237
		f 4 146 -142 -139 -146
		mu 0 4 238 239 240 241
		f 4 -147 -145 -143 -140
		mu 0 4 242 243 244 245;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh7" -p "breakingcrate_geo";
	rename -uid "95D5FD0D-4FC8-B746-D1EB-F3A832080D7B";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" 37.029716491699219 43.402213335037231 -14.332284450531006 ;
	setAttr ".sp" -type "double3" 37.029716491699219 43.402213335037231 -14.332284450531006 ;
createNode mesh -n "breakingcrate_mesh7Shape" -p "breakingcrate_mesh7";
	rename -uid "64C45AD3-475B-F5E8-41FA-BF92ABDA3F19";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh7ShapeOrig" -p "breakingcrate_mesh7";
	rename -uid "B25F9493-4DB4-13F1-9B72-208AB8D20DDE";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 246 ".uvst[0].uvsp[0:245]" -type "float2" 0.880642 0.37591699
		 0.880642 0.34324601 0.89014798 0.34324601 0.89014798 0.37597099 0.88942599 0.37669101
		 0.88117301 0.37559 0.78006798 0.576801 0.78006798 0.547396 0.81168401 0.547396 0.81168401
		 0.57795697 0.80127102 0.58048999 0.788504 0.57675397 0.98087001 0.57237202 0.97070801
		 0.57237202 0.97070801 0.55039799 0.98087001 0.55039799 0.358257 0.234209 0.358257
		 0.167749 0.402329 0.168106 0.40322399 0.168008 0.40345001 0.16800299 0.41305599 0.157867
		 0.41305599 0.234209 0.88364398 0.170248 0.88364398 0.14359801 0.89380598 0.14359801
		 0.89380598 0.173004 0.51013172 -0.35346472 0.50826508 -0.3529897 0.50658208 -0.33851489
		 0.50678015 -0.33820537 0.52807224 -0.3518286 0.50657874 -0.33824959 0.5301702 -0.33306789
		 0.52937335 -0.35202461 0.50655419 -0.33717668 0.5284844 -0.30428305 0.50614893 -0.28599048
		 0.5283497 -0.28729975 0.85903603 0.21415 0.85903603 0.233826 0.85061997 0.233826
		 0.85061997 0.21415 0.79636902 0.116356 0.76805902 0.116356 0.76805902 0.0099999998
		 0.79636902 0.0099999998 0.92508501 0.740816 0.916668 0.740816 0.916668 0.63445997
		 0.92508501 0.63445997 0.456862 0.53793198 0.40779299 0.53793198 0.40779299 0.27269399
		 0.456862 0.27269399 0.92567497 0.439316 0.93152398 0.439316 0.93152398 0.59234601
		 0.92567497 0.59234601 0.85528398 0.080551997 0.85528398 0.088969 0.83560902 0.088969
		 0.83560902 0.080551997 0.72919101 0.53629798 0.70951599 0.53629798 0.70951599 0.52788198
		 0.72919101 0.52788198 0.98212701 0.31656501 0.98212701 0.35159001 0.97371 0.35159001
		 0.97371 0.31975099 0.83560902 0.83514601 0.83560902 0.81309199 0.86391902 0.81309199
		 0.86391902 0.84811699 0.856134 0.85137999 0.85564399 0.85166502 0.85556901 0.85153699
		 0.83613902 0.83501703 0.97161901 0.91974503 0.97161901 0.941526 0.96320301 0.941526
		 0.96320301 0.91947198 0.96408898 0.91994798 0.96569401 0.919761 0.96654302 0.92050099
		 0.69553798 0.90049899 0.69553798 0.97990298 0.646469 0.97990298 0.646469 0.92558599
		 0.65899998 0.92528701 0.68723601 0.89549297 0.50291055 -0.39406058 0.49900496 -0.40657717
		 0.48109126 -0.40078226 0.48349446 -0.39308187 0.50291055 -0.39308187 0.5031727 -0.39334399
		 0.48779041 -0.35046065 0.50101781 -0.33723328 0.50291055 -0.3381837 0.50317734 -0.39308187
		 0.50616372 -0.33859366 0.50783187 -0.34026182 0.49076697 -0.33608076 0.50807899 -0.33932698
		 0.870134 0.18204901 0.870134 0.14359801 0.87963998 0.14359801 0.87963998 0.189629
		 0.763502 0.491855 0.81292999 0.491855 0.81292999 0.523471 0.776963 0.523471 0.77951902
		 0.51967901 0.77960002 0.51961398 0.77943403 0.51921999 0.97486597 0.53184199 0.96470398
		 0.53184199 0.96470398 0.50986803 0.97486597 0.50986803 0.299714 0.234209 0.299714
		 0.131667 0.33580399 0.153431 0.34619901 0.134895 0.35451299 0.126831 0.35451299 0.234209
		 0.88029599 0.29896399 0.88029599 0.34008101 0.870134 0.34008101 0.870134 0.290654
		 0.87658399 0.29755801 0.49154112 -0.43215632 0.49275574 -0.44186276 0.47449464 -0.44881624
		 0.47295806 -0.43654102 0.46967447 -0.41846582 0.49150589 -0.43196172 0.4915525 -0.4312993
		 0.47215298 -0.38348505 0.48042947 -0.38415805 0.49660423 -0.38891733 0.87463701 0.53006399
		 0.87463701 0.47534299 0.88414299 0.47534299 0.88414299 0.53817803 0.78457099 0.72530001
		 0.78457099 0.68099499 0.81618702 0.68099499 0.81618702 0.73218203 0.79456598 0.730272
		 0.79129398 0.72875398 0.788665 0.72806001 0.95385098 0.57237202 0.94368798 0.57237202
		 0.94368798 0.55039799 0.95385098 0.55039799 0.41679999 0.234209 0.41679999 0.109753
		 0.42861 0.105272 0.45114899 0.090226002 0.47159901 0.087626003 0.47159901 0.234209
		 0.880642 0.86602497 0.880642 0.81309199 0.89022303 0.81309199 0.89022303 0.86008602
		 0.88514501 0.86407101 0.49512067 -0.51635444 0.48653975 -0.56071657 0.46727258 -0.56372774
		 0.47195485 -0.53952026 0.4761076 -0.50856459 0.49616522 -0.50856459 0.47856507 -0.49353796
		 0.48797807 -0.49363208 0.49711335 -0.50276732 0.49824333 -0.4922682 0.84627801 0.37417901
		 0.82660198 0.37417901 0.82660198 0.365762 0.84627801 0.365762 0.97011799 0.38568199
		 0.97011799 0.42214301 0.96170199 0.42214301 0.96170199 0.37932301 0.83560902 0.041845001
		 0.83560902 0.0099999998 0.86391902 0.0099999998 0.86391902 0.046459999 0.85604799
		 0.045292001 0.83997798 0.043871999 0.97521198 0.90971297 0.97521102 0.87463701 0.98362797
		 0.87463701 0.98362797 0.90648198 0.710549 0.60742098 0.710549 0.71420699 0.66148001
		 0.71420699 0.66148001 0.62673199 0.68315399 0.61226398 0.69479901 0.61078399 0.47176373
		 -0.56630594 0.46873748 -0.58287072 0.45279455 -0.58542866 0.45628846 -0.56630594
		 0.47814184 -0.53333384 0.45895496 -0.55252016 0.46294835 -0.52275336 0.47953686 -0.52293289
		 0.88364398 0.68195403 0.88364398 0.63445997 0.89070702 0.63445997 0.89070702 0.68614501
		 0.88910002 0.68492198 0.799582 0.037115999 0.799582 0.0099999998 0.83119798 0.0099999998
		 0.83119798 0.043008 0.82215399 0.040635999 0.80997002 0.038550001 0.95419598 0.13875
		 0.95419598 0.12858699 0.97616899 0.12858699 0.97616899 0.13875 0.277197 0.81609398
		 0.35368401 0.81609398 0.35449201 0.81779999 0.357788 0.83439398 0.366779 0.870893
		 0.277197 0.870893 0.88364398 0.050035998 0.88364398 0.017506 0.89322501 0.017506
		 0.89322501 0.046266999 0.88443297 0.049908001 0.47702801 -0.59218848 0.47376332 -0.61212081
		 0.45809519 -0.6111213 0.45353076 -0.61103928 0.46152791 -0.56630594 0.48165539 -0.56630594
		 0.46726277 -0.54421234 0.48567188 -0.54453915 0.46522972 -0.54624546 0.46557155 -0.54401892;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 96 ".vt[0:95]"  32.11177444 63.21327209 -10.63098812 32.11177444 63.21327209 -32.20341873
		 37.097164154 63.21327209 -32.20341873 37.097164154 63.21327209 -10.59526062 36.71852493 63.21327209 -10.12014675
		 32.39062119 63.21327209 -10.84681416 32.11177444 78.72370148 -11.44700527 32.11177444 78.72370148 -32.20341873
		 32.11177444 68.3217392 -8.84364033 32.11177444 74.58473969 -11.48052311 37.097164154 78.72370148 -32.20341873
		 37.097164154 78.72370148 -13.39224529 37.097164154 66.24925995 -13.49326611 37.097164154 65.99609375 -13.46556282
		 37.097164154 65.93198395 -13.4640379 37.048229218 66.0016784668 -13.47617722 37.81857681 5.74968576 -24.06403923
		 37.81857681 5.99207687 -37.950634 41.94765854 5.99207687 -37.950634 41.94765854 5.74968576 -24.06403923
		 37.81857681 80.81235504 -22.7538147 37.81857681 81.054740906 -36.64040756 41.94765854 81.054740906 -36.64040756
		 41.94765854 80.81235504 -22.7538147 35.76576996 59.33200455 -23.60728645 35.76576996 73.22071075 -23.60728645
		 39.89485168 73.22071075 -23.60728645 39.89485168 59.33200455 -23.60728645 35.76576996 59.33200455 1.11633003
		 39.89485168 59.33200455 -1.132635 35.76576996 73.22071075 -8.039920807 35.76576996 63.15145493 3.41963792
		 35.76576996 63.39143753 3.62067389 35.76576996 63.42866898 3.53030205 35.76576996 72.96040344 -8.13099861
		 39.89485168 73.22071075 -8.23316765 36.2005806 73.22071075 -8.37646198 36.98822403 73.22071075 -8.24421406
		 37.40453339 73.22071075 -8.76659584 39.89485168 69.6738739 -8.14881229 39.89485168 61.68180084 0.284403
		 35.82969666 63.42266846 3.54837394 32.11177444 44.73800659 -6.81516314 32.11177444 44.73800659 -32.20341873
		 37.097164154 44.73800659 -32.20341873 37.097164154 44.73800659 -1.81065595 32.11177444 60.24843597 2.68602109
		 32.11177444 60.24843597 -32.20341873 32.11177444 46.59863663 -8.6200428 32.11177444 46.63034058 -8.67657757
		 32.11177444 46.82366943 -8.55999184 37.097164154 60.24843597 -32.20341873 37.097164154 60.24843597 -3.17958999
		 37.097164154 50.033306122 -9.33979416 37.097164154 47.091053009 -4.093195915 35.27607346 60.24843597 -2.18770695
		 32.11177444 28.90206146 3.92868996 32.11177444 28.90206146 -32.20341873 37.097164154 28.90206146 -32.20341873
		 37.097164154 28.90206146 9.2860651 32.11177444 44.41249466 -0.92911899 32.11177444 44.41249466 -32.20341873
		 32.11177444 39.50891876 2.58028007 32.11177444 41.11434937 1.50858498 32.11177444 42.40394974 1.019242048
		 37.097164154 44.41249466 -32.20341873 37.097164154 44.41249466 3.023189068 37.097164154 41.069633484 4.29164791
		 37.097164154 34.69012833 8.55025005 34.75370789 44.41249466 1.72294497 35.76576996 16.80956268 -23.60728645
		 35.76576996 30.69826889 -23.60728645 39.89485168 30.69826889 -23.60728645 39.89485168 16.80956268 -23.60728645
		 35.76576996 16.80956268 2.12907791 39.89485168 16.80956268 6.61778593 35.76576996 30.69826889 -1.12857997
		 35.76576996 20.67120552 1.30446005 35.76576996 28.55485916 0.302241 39.89485168 30.69826889 1.15173197
		 39.89485168 24.56375885 5.24678802 39.89485168 21.2675724 5.66581917 32.11177444 7.20095301 -8.90396118
		 32.11177444 7.20095301 -32.20341873 37.097164154 7.20095301 -32.20341873 37.097164154 7.20095301 -6.84786606
		 35.96302414 7.20095301 -7.44779491 32.11177444 22.71138573 -13.062693596 32.11177444 22.71138573 -32.20341873
		 32.11177444 11.63774872 -10.57794952 32.11177444 17.61496925 -12.050363541 37.097164154 22.71138573 -32.20341873
		 37.097164154 22.71138573 -10.55417633 37.097164154 22.22848511 -10.32566357 37.097164154 17.53162766 -9.39270115
		 36.68648911 22.71138573 -10.63914871;
	setAttr -s 147 ".ed[0:146]"  0 1 0 1 2 0 2 3 0 3 4 0 4 5 0 5 0 0 6 7 0
		 7 1 0 0 8 0 8 9 0 9 6 0 7 10 0 10 2 0 10 11 0 11 12 0 12 13 0 13 14 0 14 3 0 6 11 0
		 14 15 0 15 4 0 15 5 0 13 15 0 15 8 0 12 15 0 15 9 0 16 17 0 17 18 0 18 19 0 19 16 0
		 20 21 0 21 17 0 16 20 0 21 22 0 22 18 0 22 23 0 23 19 0 23 20 0 24 25 0 25 26 0 26 27 0
		 27 24 0 28 24 0 27 29 0 29 28 0 30 25 0 28 31 0 31 32 0 32 33 0 33 34 0 34 30 0 35 26 0
		 30 36 0 36 37 0 37 38 0 38 35 0 35 39 0 39 40 0 40 29 0 40 41 0 41 31 0 41 32 0 39 38 0
		 37 41 0 41 33 0 36 34 0 42 43 0 43 44 0 44 45 0 45 42 0 46 47 0 47 43 0 42 48 0 48 49 0
		 49 50 0 50 46 0 47 51 0 51 44 0 51 52 0 52 53 0 53 54 0 54 45 0 46 55 0 55 52 0 54 48 0
		 53 49 0 55 50 0 56 57 0 57 58 0 58 59 0 59 56 0 60 61 0 61 57 0 56 62 0 62 63 0 63 64 0
		 64 60 0 61 65 0 65 58 0 65 66 0 66 67 0 67 68 0 68 59 0 60 69 0 69 66 0 68 62 0 67 63 0
		 69 64 0 70 71 0 71 72 0 72 73 0 73 70 0 74 70 0 73 75 0 75 74 0 76 71 0 74 77 0 77 78 0
		 78 76 0 79 72 0 76 79 0 79 80 0 80 81 0 81 75 0 81 77 0 80 78 0 82 83 0 83 84 0 84 85 0
		 85 86 0 86 82 0 87 88 0 88 83 0 82 89 0 89 90 0 90 87 0 88 91 0 91 84 0 91 92 0 92 93 0
		 93 94 0 94 85 0 87 95 0 95 92 0 86 89 0 94 90 0 93 95 0;
	setAttr -s 294 ".n";
	setAttr ".n[0:165]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0
		 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0.65340102 0.54946601
		 0.52072501 0.65340102 0.54946601 0.52072501 0.65340102 0.54946601 0.52072501 0.65340102
		 0.54946601 0.52072501 -0.105665 0.76992702 0.62932301 -0.105665 0.76992702 0.62932301
		 -0.105665 0.76992702 0.62932301 -0.209401 0.023269 0.97755301 -0.20162 0.087608002
		 0.97553802 -0.20048501 0.096413001 0.97494102 0.58990997 -0.266664 0.76216501 0.58990997
		 -0.266664 0.76216501 0.58990997 -0.266664 0.76216501 0.58990997 -0.266664 0.76216501
		 -0.20162 0.087608002 0.97553802 -0.19915199 0.106594 0.974154 -0.20048501 0.096413001
		 0.97494102 0.72324198 0.26797599 0.63648301 0.72324198 0.26797599 0.63648301 0.72324198
		 0.26797599 0.63648301 0.36348701 -0.0075440002 0.93156898 0.36348701 -0.0075440002
		 0.93156898 0.36348701 -0.0075440002 0.93156898 0.36348701 -0.0075440002 0.93156898
		 0.36348701 -0.0075440002 0.93156898 0 -0.99984801 -0.017452 0 -0.99984801 -0.017452
		 0 -0.99984801 -0.017452 0 -0.99984801 -0.017452 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0.017452
		 -0.99984801 0 0.017452 -0.99984801 0 0.017452 -0.99984801 0 0.017452 -0.99984801
		 1 0 0 1 0 0 1 0 0 1 0 0 0 -0.017452 0.99984801 0 -0.017452 0.99984801 0 -0.017452
		 0.99984801 0 -0.017452 0.99984801 0 0.99984801 0.017452 0 0.99984801 0.017452 0 0.99984801
		 0.017452 0 0.99984801 0.017452 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0
		 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0.422739 -0.46800801 0.77605402
		 0.42269999 -0.468009 0.77607501 0.42269999 -0.468009 0.77607501 0.42269999 -0.468009
		 0.77607501 0.423125 -0.46800199 0.77584797 0.76309401 -0.415023 0.49542201 0.422739
		 -0.46800801 0.77605402 0.423125 -0.46800199 0.77584797 0.65340102 0.54946703 0.520724
		 0.65340102 0.54946703 0.520724 0.65340102 0.54946703 0.520724 0.65340102 0.54946601
		 0.520724 0.65340102 0.54946601 0.520724 -0.105645 0.76996702 0.629278 -0.020889999
		 0.92439097 0.38087299 -0.105641 0.76997602 0.62926698 -0.105641 0.76997602 0.62926698
		 -0.105663 0.769925 0.62932599 -0.105663 0.769925 0.62932599 -0.105663 0.769925 0.62932599
		 -0.105645 0.76996702 0.629278 -0.20939399 0.023250001 0.97755498 -0.20939399 0.023250001
		 0.97755498 -0.20939399 0.023250001 0.97755498 0.58991802 -0.266666 0.76215899 0.58991802
		 -0.266666 0.76215899 0.58991802 -0.266666 0.76215899 0 -1 0 0 -1 0 0 -1 0 0 -1 0
		 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0
		 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.51476002 0.70322198
		 0.490408 -0.58458799 0.564906 0.58235598 -0.58458799 0.564906 0.58235598 -0.55214298
		 0.63620698 0.53886801 -0.55214298 0.63620698 0.53886801 -0.468494 0.77056903 0.43213001
		 -0.468494 0.77056903 0.43213001 -0.51476002 0.70322198 0.490408;
	setAttr ".n[166:293]" -type "float3"  0.45685199 -0.46704 0.75707299 0.42269999
		 -0.46801001 0.77607399 0.42269999 -0.46801001 0.77607399 0.42269999 -0.46801001 0.77607399
		 0.60953301 -0.45260999 0.65085602 0.60953301 -0.45260999 0.65085602 0.76308203 -0.41502899
		 0.49543601 0.45685199 -0.46704 0.75707299 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0 1 0 0 1 0
		 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.72933501 0.086278997 0.67869401
		 -0.72933501 0.086278997 0.67869502 -0.72933501 0.086278997 0.67869401 -0.72933501
		 0.086278997 0.67869401 -0.417395 0.504529 0.755799 -0.43337199 0.44538301 0.78346902
		 -0.43973699 0.41891399 0.79444498 -0.417395 0.504529 0.755799 -0.43337199 0.44538301
		 0.78346902 -0.46047899 0.31492001 0.82993102 -0.472996 0.336932 0.81409597 -0.48258501
		 0.35410801 0.80107403 -0.43973699 0.41891399 0.79444498 -0.472996 0.336932 0.81409597
		 -0.584589 0.56490499 0.58235598 -0.48258501 0.35410801 0.80107403 0 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 -0.72923499 0.11031 0.675313
		 -0.72840202 0.14308199 0.670044 -0.72840202 0.14308199 0.670044 -0.72922403 0.111152
		 0.675188 -0.72933501 0.086280003 0.67869401 -0.72923499 0.11031 0.675313 -0.72922403
		 0.111152 0.675188 -0.72933501 0.086280003 0.67869401 -0.417395 0.504529 0.755799
		 -0.417395 0.504529 0.755799 -0.417395 0.504529 0.755799 -0.417395 0.504529 0.755799
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0
		 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1
		 0 0 1 0 -0.45103201 0.21892001 0.865242 -0.333507 0.33279601 0.88205498 -0.44987801
		 0.22013 0.86553597 -0.44987801 0.22013 0.86553597 -0.45687801 0.21276399 0.86370897
		 -0.45837599 0.199402 0.86610001 -0.458675 0.19664 0.86657399 -0.45103201 0.21892001
		 0.865242 -0.460751 0.173237 0.87045801 -0.461086 0.172883 0.87035102 -0.458675 0.19664
		 0.86657399 -0.45837599 0.199402 0.86610001 -0.460843 0.17314 0.87042898 -0.460843
		 0.17314 0.87042898 -0.183841 0.42044899 0.88849598 -0.460751 0.173237 0.87045801;
	setAttr -s 65 -ch 294 ".fc[0:64]" -type "polyFaces" 
		f 6 0 1 2 3 4 5
		mu 0 6 0 1 2 3 4 5
		f 6 6 7 -1 8 9 10
		mu 0 6 6 7 8 9 10 11
		f 4 11 12 -2 -8
		mu 0 4 12 13 14 15
		f 7 13 14 15 16 17 -3 -13
		mu 0 7 16 17 18 19 20 21 22
		f 4 -14 -12 -7 18
		mu 0 4 23 24 25 26
		f 4 -4 -18 19 20
		mu 0 4 27 28 29 30
		f 3 -5 -21 21
		mu 0 3 31 27 30
		f 3 -17 22 -20
		mu 0 3 29 32 30
		f 4 -9 -6 -22 23
		mu 0 4 33 34 31 30
		f 3 -16 24 -23
		mu 0 3 32 35 30
		f 3 -10 -24 25
		mu 0 3 36 33 30
		f 5 -25 -15 -19 -11 -26
		mu 0 5 30 35 37 38 36
		f 4 26 27 28 29
		mu 0 4 39 40 41 42
		f 4 30 31 -27 32
		mu 0 4 43 44 45 46
		f 4 33 34 -28 -32
		mu 0 4 47 48 49 50
		f 4 35 36 -29 -35
		mu 0 4 51 52 53 54
		f 4 37 -33 -30 -37
		mu 0 4 55 56 57 58
		f 4 -38 -36 -34 -31
		mu 0 4 59 60 61 62
		f 4 38 39 40 41
		mu 0 4 63 64 65 66
		f 4 42 -42 43 44
		mu 0 4 67 68 69 70
		f 8 45 -39 -43 46 47 48 49 50
		mu 0 8 71 72 73 74 75 76 77 78
		f 7 51 -40 -46 52 53 54 55
		mu 0 7 79 80 81 82 83 84 85
		f 6 -44 -41 -52 56 57 58
		mu 0 6 86 87 88 89 90 91
		f 5 -47 -45 -59 59 60
		mu 0 5 92 93 94 95 96
		f 3 -48 -61 61
		mu 0 3 97 92 96
		f 5 -60 -58 62 -55 63
		mu 0 5 96 95 98 99 100
		f 3 -49 -62 64
		mu 0 3 101 97 96
		f 5 -64 -54 65 -50 -65
		mu 0 5 96 100 102 103 101
		f 3 -57 -56 -63
		mu 0 3 98 104 99
		f 3 -53 -51 -66
		mu 0 3 102 105 103
		f 4 66 67 68 69
		mu 0 4 106 107 108 109
		f 7 70 71 -67 72 73 74 75
		mu 0 7 110 111 112 113 114 115 116
		f 4 76 77 -68 -72
		mu 0 4 117 118 119 120
		f 6 78 79 80 81 -69 -78
		mu 0 6 121 122 123 124 125 126
		f 5 -79 -77 -71 82 83
		mu 0 5 127 128 129 130 131
		f 4 -73 -70 -82 84
		mu 0 4 132 133 134 135
		f 4 -81 85 -74 -85
		mu 0 4 135 136 137 132
		f 5 -75 -86 -80 -84 86
		mu 0 5 138 137 136 139 140
		f 3 -83 -76 -87
		mu 0 3 140 141 138
		f 4 87 88 89 90
		mu 0 4 142 143 144 145
		f 7 91 92 -88 93 94 95 96
		mu 0 7 146 147 148 149 150 151 152
		f 4 97 98 -89 -93
		mu 0 4 153 154 155 156
		f 6 99 100 101 102 -90 -99
		mu 0 6 157 158 159 160 161 162
		f 5 -100 -98 -92 103 104
		mu 0 5 163 164 165 166 167
		f 4 -94 -91 -103 105
		mu 0 4 168 169 170 171
		f 4 -102 106 -95 -106
		mu 0 4 171 172 173 168
		f 5 -101 -105 107 -96 -107
		mu 0 5 172 174 175 176 173
		f 3 -104 -97 -108
		mu 0 3 175 177 176
		f 4 108 109 110 111
		mu 0 4 178 179 180 181
		f 4 112 -112 113 114
		mu 0 4 182 183 184 185
		f 6 115 -109 -113 116 117 118
		mu 0 6 186 187 188 189 190 191
		f 4 119 -110 -116 120
		mu 0 4 192 193 194 195
		f 6 -114 -111 -120 121 122 123
		mu 0 6 196 197 198 199 200 201
		f 4 -117 -115 -124 124
		mu 0 4 202 203 204 205
		f 4 -118 -125 -123 125
		mu 0 4 206 202 205 207
		f 4 -122 -121 -119 -126
		mu 0 4 207 208 209 206
		f 5 126 127 128 129 130
		mu 0 5 210 211 212 213 214
		f 6 131 132 -127 133 134 135
		mu 0 6 215 216 217 218 219 220
		f 4 136 137 -128 -133
		mu 0 4 221 222 223 224
		f 6 138 139 140 141 -129 -138
		mu 0 6 225 226 227 228 229 230
		f 5 -139 -137 -132 142 143
		mu 0 5 231 232 233 234 235
		f 3 -134 -131 144
		mu 0 3 236 237 238
		f 5 -130 -142 145 -135 -145
		mu 0 5 238 239 240 241 236
		f 5 -143 -136 -146 -141 146
		mu 0 5 242 243 241 240 244
		f 3 -140 -144 -147
		mu 0 3 244 245 242;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh8" -p "breakingcrate_geo";
	rename -uid "197ABAD5-4250-1588-F3AB-F7B72E5E9565";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" 7.1549749374389648 43.402216911315918 -36.956401824951172 ;
	setAttr ".sp" -type "double3" 7.1549749374389648 43.402216911315918 -36.956401824951172 ;
createNode mesh -n "breakingcrate_mesh8Shape" -p "breakingcrate_mesh8";
	rename -uid "D8A45488-4EA1-9496-3FFB-7686867089C0";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh8ShapeOrig" -p "breakingcrate_mesh8";
	rename -uid "9FB05CFD-4202-5C41-61F0-6B989DC00042";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 223 ".uvst[0].uvsp[0:222]" -type "float2" 0.86713201 0.40843001
		 0.86713201 0.34324601 0.876638 0.34324601 0.876638 0.40785399 0.86741501 0.40870899
		 0.068543002 0.65705502 0.068543002 0.547396 0.123342 0.547396 0.123342 0.699458 0.122944
		 0.699579 0.117194 0.69104898 0.1081 0.69032198 0.087590002 0.67221498 0.083039001
		 0.66874301 0.85662401 0.76170897 0.85662401 0.75154698 0.87859702 0.75154698 0.87859702
		 0.76170897 0.66598397 0.48863 0.66598397 0.43883601 0.67404199 0.43456301 0.67750603
		 0.432437 0.69439602 0.43149799 0.69760001 0.428195 0.69760001 0.48863 0.68275398
		 0.26334101 0.63295901 0.26334101 0.63295901 0.25317901 0.67693001 0.25317901 0.68110299
		 0.26032999 0.46873778 -0.45039475 0.46856859 -0.45089078 0.46972057 -0.45137697 0.46579817
		 -0.43553561 0.49509093 -0.44988608 0.49225238 -0.43553561 0.46783242 -0.42158183
		 0.49879965 -0.39061457 0.46379685 -0.37779427 0.49761829 -0.37779427 0.4631871 -0.36848578
		 0.49574742 -0.34922904 0.4855226 -0.34614971 0.46091613 -0.33836788 0.82359999 0.67665303
		 0.82359999 0.656977 0.83201599 0.656977 0.83201599 0.67665303 0.39982 0.812635 0.35075101
		 0.812635 0.35075101 0.547396 0.39982 0.547396 0.910074 0.58169901 0.90165699 0.58169901
		 0.90165699 0.47534299 0.910074 0.47534299 0.79937202 0.249955 0.771061 0.249955 0.771061
		 0.14359801 0.79937202 0.14359801 0.928087 0.91944802 0.919671 0.91944802 0.919671
		 0.81309199 0.928087 0.81309199 0.77722698 0.52788198 0.77722698 0.53629798 0.75755101
		 0.53629798 0.75755101 0.52788198 0.85662401 0.70081103 0.85662401 0.63445997 0.86612999
		 0.63445997 0.86612999 0.70232499 0.85853797 0.70016497 0.0099999998 0.44795299 0.0099999998
		 0.278698 0.064799003 0.278698 0.064799003 0.43348101 0.053587001 0.45017201 0.026388001
		 0.44115201 0.014275 0.44586301 0.966205 0.123739 0.966205 0.113576 0.98817801 0.113576
		 0.98817801 0.123739 0.59242898 0.181126 0.67221999 0.181126 0.66508597 0.185258 0.66426498
		 0.185721 0.66415101 0.186056 0.65925097 0.20418499 0.65945101 0.205054 0.65897602
		 0.205512 0.65591103 0.212743 0.59242898 0.212743 0.68873298 0.80073798 0.60894102
		 0.80073798 0.60894102 0.79057503 0.67681003 0.79057503 0.68036997 0.79711801 0.68529302
		 0.79920101 0.45925176 -0.5510183 0.45152652 -0.57844543 0.45603555 -0.57948709 0.48255962
		 -0.55296308 0.4831076 -0.5510183 0.4482474 -0.51476079 0.48249841 -0.54901236 0.48054039
		 -0.57688528 0.48338822 -0.49327695 0.4485898 -0.49327695 0.47161648 -0.48038852 0.44896802
		 -0.48543221 0.48343959 -0.49221164 0.48450434 -0.48972818 0.48450434 -0.47300225
		 0.49372277 -0.46784768 0.84761697 0.52549899 0.84761697 0.47534299 0.85777998 0.47534299
		 0.85777998 0.53022999 0.0099999998 0.16345701 0.0099999998 0.0099999998 0.064799003
		 0.0099999998 0.064799003 0.135084 0.059923999 0.13489 0.053080998 0.135334 0.027170001
		 0.14709599 0.0195 0.15105499 0.91031802 0.46129 0.90015602 0.46129 0.90015602 0.439316
		 0.91031802 0.439316 0.59242898 0.217153 0.65338802 0.217153 0.64949602 0.227999 0.64799303
		 0.232765 0.64729899 0.248153 0.64731598 0.248769 0.59242898 0.248769 0.85027403 0.92904103
		 0.85027403 0.99000001 0.84011197 0.99000001 0.84011197 0.92846698 0.84611601 0.93003601
		 0.43878073 -0.66650099 0.43982005 -0.67407149 0.47383606 -0.66815877 0.47360799 -0.66650099
		 0.43775234 -0.65551108 0.46960014 -0.62366325 0.43991649 -0.6087597 0.47029015 -0.6087597
		 0.44084439 -0.59467828 0.47256401 -0.57424361 0.46005437 -0.57546777 0.44649842 -0.57341737
		 0.65713799 0.53629798 0.63746202 0.53629798 0.63746202 0.52788198 0.65713799 0.52788198
		 0.64300001 0.97990203 0.59393001 0.97990203 0.59393001 0.81309199 0.64300001 0.81309199
		 0.96170199 0.284702 0.97011799 0.284702 0.97011799 0.35159099 0.96170199 0.35159099
		 0.86646998 0.103069 0.86646998 0.13137899 0.799582 0.13137899 0.799582 0.103069 0.985129
		 0.28103799 0.976713 0.28103799 0.976713 0.21415 0.985129 0.21415 0.773853 0.67048699
		 0.773853 0.676337 0.74554199 0.676337 0.74554199 0.67048699 0.75859398 0.656977 0.82037503
		 0.656977 0.82037503 0.66713899 0.75727999 0.66713899 0.75826299 0.662094 0.0099999998
		 0.71782303 0.0099999998 0.547396 0.064799003 0.547396 0.064799003 0.70147002 0.058189001
		 0.70216 0.029410001 0.72564501 0.023267999 0.729922 0.018193001 0.72564501 0.91782397
		 0.76601398 0.90766197 0.76601398 0.90766197 0.74404103 0.91782397 0.74404103 0.69750702
		 0.116356 0.69750702 0.049810998 0.70516199 0.045327 0.71961099 0.052322 0.72531003
		 0.052965 0.729123 0.053261001 0.729123 0.116356 0.56869602 0.25978601 0.46633601
		 0.25978601 0.46633601 0.25317901 0.571455 0.25317901 0.57146001 0.25429201 0.41297495
		 -0.6087597 0.41256961 -0.61968839 0.426763 -0.61968839 0.426763 -0.6087597 0.426763
		 -0.56117332 0.44171974 -0.61968839 0.4421528 -0.6087597 0.42927474 -0.5510183 0.44309515
		 -0.59242749 0.45333672 -0.5510183 0.426763 -0.5426262 0.44677097 -0.5290789 0.426763
		 -0.5290789 0.42217025 -0.5290789;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 88 ".vt[0:87]"  -5.50301886 63.21327209 -37.53705215 37.53705215 63.21327209 -37.53705215
		 37.53705215 63.21327209 -32.55166245 -5.12265921 63.21327209 -32.55166245 -5.68710184 63.21327209 -37.38856125
		 6.49893093 78.72370148 -37.53705215 37.53705215 78.72370148 -37.53705215 -5.53739405 63.32588196 -37.53705215
		 -3.12303805 64.95353699 -37.53705215 -2.91721392 67.5273056 -37.53705215 2.20788693 73.3325882 -37.53705215
		 3.19071388 74.6207962 -37.53705215 37.53705215 78.72370148 -32.55166245 2.3881011 78.72370148 -32.55166245
		 -0.62786698 74.77061462 -32.55166245 -2.128407 73.070930481 -32.55166245 -2.7910161 64.78516388 -32.55166245
		 3.55357504 78.72370148 -34.029037476 23.55450058 5.8651638 -41.94765854 37.4432106 5.8651638 -41.94765854
		 37.4432106 5.8651638 -37.81857681 23.55450058 5.8651638 -37.81857681 23.55450058 80.93927002 -41.94765854
		 37.4432106 80.93927002 -41.94765854 37.4432106 80.93927002 -37.81857681 23.55450058 80.93927002 -37.81857681
		 -6.27325296 44.73800659 -36.95053482 37.53705215 44.73800659 -36.95053482 37.53705215 44.73800659 -31.96514511
		 -7.27307796 44.73800659 -31.96514511 -5.84713221 44.73800659 -35.94696808 -10.36940289 60.24843597 -36.95053482
		 37.53705215 60.24843597 -36.95053482 -10.99748611 47.91139221 -36.95053482 -8.44431782 55.60993958 -36.95053482
		 -9.77772808 59.038318634 -36.95053482 37.53705215 60.24843597 -31.96514511 -18.78546524 60.24843597 -31.96514511
		 -13.74949074 58.22135925 -31.96514511 -13.17016983 57.99431992 -31.96514511 -13.089850426 57.83004761 -31.96514511
		 -9.63064194 48.93595123 -31.96514511 -9.77188683 48.51005936 -31.96514511 -9.43691063 48.28504562 -31.96514511
		 -12.88234901 60.24843597 -33.74060822 -16.3578701 60.24843597 -32.71890259 2.13294101 28.90206146 -37.53705215
		 37.53705215 28.90206146 -37.53705215 37.53705215 28.90206146 -32.55166245 -1.20618296 28.90206146 -32.55166245
		 -5.89792824 44.41249466 -37.53705215 37.53705215 44.41249466 -37.53705215 2.18788099 30.28201294 -37.53705215
		 2.06223011 32.21866226 -37.53705215 -1.26708603 39.55273056 -37.53705215 -2.38770103 41.72353363 -37.53705215
		 37.53705215 44.41249466 -32.55166245 -5.49213982 44.41249466 -32.55166245 -2.74528503 39.091411591 -32.55166245
		 -1.68394101 36.75340271 -32.55166245 -1.19415104 29.20428658 -32.55166245 -4.78982019 44.41249466 -34.59166336
		 23.98567581 16.60381889 -40.77462387 24.10687637 30.49199486 -40.77462387 24.10687637 30.49199486 -36.64554596
		 23.98567581 16.60381889 -36.64554596 -23.22710228 17.015838623 -40.77462387 -23.10589981 30.90401268 -40.77462387
		 -23.10589981 30.90401268 -36.64554596 -23.22710228 17.015838623 -36.64554596 -6.072668076 7.20095301 -37.53705215
		 37.53705215 7.20095301 -37.53705215 37.53705215 7.20095301 -32.55166245 -7.00025320053 7.20095301 -32.55166245
		 -6.30647278 7.20095301 -35.026920319 -10.70102882 22.71138573 -37.53705215 37.53705215 22.71138573 -37.53705215
		 -6.26795292 9.071750641 -37.53705215 -12.91499233 17.21757698 -37.53705215 -14.12580204 18.95588303 -37.53705215
		 -12.91499233 20.39240265 -37.53705215 37.53705215 22.71138573 -32.55166245 -9.43526745 22.71138573 -32.55166245
		 -12.60069656 18.95588303 -32.55166245 -7.66331577 11.86749935 -32.55166245 -7.20894384 9.071750641 -32.55166245
		 -10.70339298 22.71138573 -36.69701385 -6.49508476 9.071750641 -35.098560333;
	setAttr -s 133 ".ed[0:132]"  0 1 0 1 2 0 2 3 0 3 4 0 4 0 0 5 6 0 6 1 0
		 0 7 0 7 8 0 8 9 0 9 10 0 10 11 0 11 5 0 6 12 0 12 2 0 12 13 0 13 14 0 14 15 0 15 16 0
		 16 3 0 5 17 0 17 13 0 4 7 0 16 8 0 15 9 0 14 10 0 17 11 0 18 19 0 19 20 0 20 21 0
		 21 18 0 22 23 0 23 19 0 18 22 0 23 24 0 24 20 0 24 25 0 25 21 0 25 22 0 26 27 0 27 28 0
		 28 29 0 29 30 0 30 26 0 31 32 0 32 27 0 26 33 0 33 34 0 34 35 0 35 31 0 32 36 0 36 28 0
		 36 37 0 37 38 0 38 39 0 39 40 0 40 41 0 41 42 0 42 43 0 43 29 0 31 44 0 44 45 0 45 37 0
		 30 43 0 42 33 0 41 34 0 40 35 0 39 44 0 38 45 0 46 47 0 47 48 0 48 49 0 49 46 0 50 51 0
		 51 47 0 46 52 0 52 53 0 53 54 0 54 55 0 55 50 0 51 56 0 56 48 0 56 57 0 57 58 0 58 59 0
		 59 60 0 60 49 0 50 61 0 61 57 0 60 52 0 59 53 0 58 54 0 61 55 0 62 63 0 63 64 0 64 65 0
		 65 62 0 66 67 0 67 63 0 62 66 0 67 68 0 68 64 0 68 69 0 69 65 0 69 66 0 70 71 0 71 72 0
		 72 73 0 73 74 0 74 70 0 75 76 0 76 71 0 70 77 0 77 78 0 78 79 0 79 80 0 80 75 0 76 81 0
		 81 72 0 81 82 0 82 83 0 83 84 0 84 85 0 85 73 0 75 86 0 86 82 0 74 87 0 87 77 0 87 78 0
		 85 87 0 87 84 0 83 79 0 86 80 0;
	setAttr -s 266 ".n";
	setAttr ".n[0:165]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0 1 0 0 1 0 0 1
		 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.61663699
		 -0.188228 -0.76441401 -0.61663699 -0.188228 -0.76441401 -0.61663699 -0.188228 -0.76441401
		 -0.55780703 0.82741398 0.065094002 -0.55780703 0.82741398 0.065094002 -0.55780703
		 0.82741398 0.065094002 -0.55780703 0.82741398 0.065094002 -0.55780703 0.82741398
		 0.065094002 -0.99444801 0.079526 0.068915002 -0.99444801 0.079526 0.068915002 -0.99444801
		 0.079526 0.068915002 -0.99444801 0.079526 0.068915002 -0.65553701 0.53943002 -0.528476
		 -0.63790202 0.56316203 -0.52529001 -0.63790202 0.56316203 -0.52529001 -0.65290898
		 0.54304701 -0.52802402 -0.67021501 0.51565403 -0.53377199 -0.65553701 0.53943002
		 -0.528476 -0.65290898 0.54304701 -0.52802402 -0.67352498 0.51385897 -0.531331 -0.669231
		 0.51618397 -0.53449398 -0.669231 0.51618397 -0.53449398 -0.65162498 0.52541101 -0.54710901
		 -0.67021501 0.51565403 -0.53377199 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0
		 -1 0 0 -1 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1
		 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0
		 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0
		 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.54260302
		 -0.80777502 0.23039301 -0.54260302 -0.80777502 0.23039301 -0.54260302 -0.80777502
		 0.23039301 -0.54260302 -0.80777502 0.23039301 -0.54260302 -0.80777502 0.23039301
		 -0.93152201 0.30893299 0.19190601 -0.93152201 0.30893299 0.19190601 -0.93152201 0.30893299
		 0.19190601 -0.93152201 0.30893299 0.19190601 -0.81638902 -0.49803001 -0.29236099
		 -0.81638902 -0.49803001 -0.29236099 -0.81638902 -0.49803001 -0.29236099 -0.760993
		 -0.295975 -0.57731098 -0.75606799 -0.30869499 -0.57712197 -0.756428 -0.30777901 -0.57713902
		 -0.760993 -0.295975 -0.57731098 -0.734828 -0.35928699 -0.57527399 -0.734828 -0.35928699
		 -0.57527399 -0.756428 -0.30777901 -0.57713902 -0.75606799 -0.30869499 -0.57712197
		 -0.734828 -0.35928699 -0.57527399 -0.228917 -0.584126 -0.77871299 -0.22961099 -0.584764
		 -0.77802998 -0.235038 -0.58973801 -0.772636 -0.228918 -0.584126 -0.77871299 -0.22961099
		 -0.584764 -0.77802998 -0.23874301 -0.593117 -0.76890498 -0.235038 -0.58973801 -0.772636
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0
		 0 1 0 0 1 0 0 1 0;
	setAttr ".n[166:265]" -type "float3"  -0.82248598 -0.042647 -0.56718397 -0.83039999
		 0.033059999 -0.55618602 -0.83039999 0.033059999 -0.55618602 -0.82312697 -0.037896998
		 -0.56659198 -0.84814698 -0.13850901 -0.51133299 -0.82248598 -0.042647 -0.56718397
		 -0.82312697 -0.037896998 -0.56659198 -0.87365597 -0.30484799 -0.379199 -0.86096197
		 -0.415306 -0.29371101 -0.84814698 -0.13850901 -0.51133299 -0.87365597 -0.30484799
		 -0.379199 -0.86039102 -0.41652599 -0.29365399 -0.84971601 -0.43864101 -0.29253501
		 -0.86096197 -0.415306 -0.29371101 -0.86039102 -0.41652599 -0.29365399 -0.84971601
		 -0.43864101 -0.29253501 -0.84971601 -0.43864101 -0.29253501 -0.59280002 -0.77385402
		 0.223021 -0.59280002 -0.77385402 0.223021 -0.59280002 -0.77385402 0.223021 0.99996197
		 -0.0087270001 0 0.99996197 -0.0087270001 0 0.99996197 -0.0087270001 0 0.99996197
		 -0.0087270001 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0.0087270001 0.99996197 0 0.0087270001
		 0.99996197 0 0.0087270001 0.99996197 0 0.0087270001 0.99996197 0 0 0 1 0 0 1 0 0
		 1 0 0 1 -0.0087270001 -0.99996197 0 -0.0087270001 -0.99996197 0 -0.0087270001 -0.99996197
		 0 -0.0087270001 -0.99996197 0 -0.99996197 0.0087270001 0 -0.99996197 0.0087270001
		 0 -0.99996197 0.0087270001 0 -0.99996197 0.0087270001 0 0 -1 0 0 -1 0 0 -1 0 0 -1
		 0 0 -1 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0 1 0 0 1 0
		 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.99035501
		 -0.10338 -0.092246003 -0.99035501 -0.10338 -0.092246003 -0.977193 -0.105575 -0.18425
		 -0.97394902 -0.113716 -0.196196 -0.79627401 -0.556701 0.23671199 -0.77277303 -0.63058698
		 -0.07198 -0.79789799 -0.58313501 0.152684 -0.97394902 -0.113716 -0.196196 -0.977193
		 -0.105575 -0.18425 -0.95738602 -0.106798 -0.268341 -0.95496303 -0.128069 -0.267663
		 -0.79587001 -0.55435997 0.243469 -0.79627401 -0.556701 0.23671199 -0.79789799 -0.58313501
		 0.152684 -0.79587001 -0.55435997 0.243469 -0.79587001 -0.55435997 0.243469 -0.95496303
		 -0.128069 -0.267663 -0.95131397 -0.15460999 -0.26664001 -0.97394902 -0.113716 -0.196196
		 -0.744524 0.62794697 0.226643 -0.744524 0.62754202 0.227762 -0.744524 0.62754202
		 0.227762 -0.744524 0.62754202 0.227762 -0.74449998 0.63039201 0.219833 -0.74449998
		 0.63039201 0.219833 -0.72329301 0.69053799 -0.0020339999 -0.744524 0.62794697 0.226643;
	setAttr -s 57 -ch 266 ".fc[0:56]" -type "polyFaces" 
		f 5 0 1 2 3 4
		mu 0 5 0 1 2 3 4
		f 9 5 6 -1 7 8 9 10 11 12
		mu 0 9 5 6 7 8 9 10 11 12 13
		f 4 13 14 -2 -7
		mu 0 4 14 15 16 17
		f 7 15 16 17 18 19 -3 -15
		mu 0 7 18 19 20 21 22 23 24
		f 5 -16 -14 -6 20 21
		mu 0 5 25 26 27 28 29
		f 3 -8 -5 22
		mu 0 3 30 31 32
		f 5 -9 -23 -4 -20 23
		mu 0 5 33 30 32 34 35
		f 4 -10 -24 -19 24
		mu 0 4 36 33 35 37
		f 4 -11 -25 -18 25
		mu 0 4 38 36 37 39
		f 5 -12 -26 -17 -22 26
		mu 0 5 40 38 39 41 42
		f 3 -21 -13 -27
		mu 0 3 42 43 40
		f 4 27 28 29 30
		mu 0 4 44 45 46 47
		f 4 31 32 -28 33
		mu 0 4 48 49 50 51
		f 4 34 35 -29 -33
		mu 0 4 52 53 54 55
		f 4 36 37 -30 -36
		mu 0 4 56 57 58 59
		f 4 38 -34 -31 -38
		mu 0 4 60 61 62 63
		f 4 -39 -37 -35 -32
		mu 0 4 64 65 66 67
		f 5 39 40 41 42 43
		mu 0 5 68 69 70 71 72
		f 7 44 45 -40 46 47 48 49
		mu 0 7 73 74 75 76 77 78 79
		f 4 50 51 -41 -46
		mu 0 4 80 81 82 83
		f 10 52 53 54 55 56 57 58 59 -42 -52
		mu 0 10 84 85 86 87 88 89 90 91 92 93
		f 6 -53 -51 -45 60 61 62
		mu 0 6 94 95 96 97 98 99
		f 5 -47 -44 63 -59 64
		mu 0 5 100 101 102 103 104
		f 4 -48 -65 -58 65
		mu 0 4 105 100 104 106
		f 3 -43 -60 -64
		mu 0 3 102 107 103
		f 4 -57 66 -49 -66
		mu 0 4 106 108 109 105
		f 5 -61 -50 -67 -56 67
		mu 0 5 110 111 109 108 112
		f 4 -55 68 -62 -68
		mu 0 4 112 113 114 110
		f 3 -54 -63 -69
		mu 0 3 113 115 114
		f 4 69 70 71 72
		mu 0 4 116 117 118 119
		f 8 73 74 -70 75 76 77 78 79
		mu 0 8 120 121 122 123 124 125 126 127
		f 4 80 81 -71 -75
		mu 0 4 128 129 130 131
		f 7 82 83 84 85 86 -72 -82
		mu 0 7 132 133 134 135 136 137 138
		f 5 -83 -81 -74 87 88
		mu 0 5 139 140 141 142 143
		f 4 -76 -73 -87 89
		mu 0 4 144 145 146 147
		f 4 -77 -90 -86 90
		mu 0 4 148 144 147 149
		f 4 -78 -91 -85 91
		mu 0 4 150 148 149 151
		f 5 -79 -92 -84 -89 92
		mu 0 5 152 150 151 153 154
		f 3 -88 -80 -93
		mu 0 3 154 155 152
		f 4 93 94 95 96
		mu 0 4 156 157 158 159
		f 4 97 98 -94 99
		mu 0 4 160 161 162 163
		f 4 100 101 -95 -99
		mu 0 4 164 165 166 167
		f 4 102 103 -96 -102
		mu 0 4 168 169 170 171
		f 4 104 -100 -97 -104
		mu 0 4 172 173 174 175
		f 4 -105 -103 -101 -98
		mu 0 4 176 177 178 179
		f 5 105 106 107 108 109
		mu 0 5 180 181 182 183 184
		f 8 110 111 -106 112 113 114 115 116
		mu 0 8 185 186 187 188 189 190 191 192
		f 4 117 118 -107 -112
		mu 0 4 193 194 195 196
		f 7 119 120 121 122 123 -108 -119
		mu 0 7 197 198 199 200 201 202 203
		f 5 -120 -118 -111 124 125
		mu 0 5 204 205 206 207 208
		f 4 -113 -110 126 127
		mu 0 4 209 210 211 212
		f 3 -114 -128 128
		mu 0 3 213 209 212
		f 4 -127 -109 -124 129
		mu 0 4 212 211 214 215
		f 5 -115 -129 130 -122 131
		mu 0 5 216 213 212 217 218
		f 3 -123 -131 -130
		mu 0 3 215 217 212
		f 5 -116 -132 -121 -126 132
		mu 0 5 219 216 218 220 221
		f 3 -125 -117 -133
		mu 0 3 221 222 219;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh9" -p "breakingcrate_geo";
	rename -uid "733A61D1-42D5-E7C8-5D11-62BFA26DF116";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" -17.808063745498657 25.081090211868286 -37.249660491943359 ;
	setAttr ".sp" -type "double3" -17.808063745498657 25.081090211868286 -37.249660491943359 ;
createNode mesh -n "breakingcrate_mesh9Shape" -p "breakingcrate_mesh9";
	rename -uid "C932AD36-4AE0-BDAE-FC74-CD8E43CAD0E1";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh9ShapeOrig" -p "breakingcrate_mesh9";
	rename -uid "CA90D4BC-483E-2EA3-30C4-76A6F842E07F";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 119 ".uvst[0].uvsp[0:118]" -type "float2" 0.85777998 0.53022999
		 0.85777998 0.58169901 0.84761697 0.58169901 0.84761697 0.52549899 0.65338802 0.217153
		 0.69878501 0.217153 0.69878501 0.248769 0.64731598 0.248769 0.64729899 0.248153 0.64799303
		 0.232765 0.64949602 0.227999 0.87463701 0.591986 0.87463701 0.58492398 0.90625399
		 0.58492398 0.90625399 0.591986 0.0099999998 0.27523899 0.0099999998 0.16345701 0.0195
		 0.15105499 0.027170001 0.14709599 0.053080998 0.135334 0.059923999 0.13489 0.064799003
		 0.135084 0.064799003 0.27523899 0.84011197 0.88364398 0.85027403 0.88364398 0.85027403
		 0.92904103 0.84611601 0.93003601 0.84011197 0.92846698 0.46681586 -0.67259967 0.46704337
		 -0.67425799 0.43302736 -0.68017012 0.431988 -0.67259967 0.46280804 -0.62976253 0.43096021
		 -0.66161031 0.43312436 -0.61485833 0.46349806 -0.61485833 0.45326224 -0.58156693
		 0.46577132 -0.58034229 0.43405169 -0.60077691 0.43970573 -0.57951599 0.714019 0.656977
		 0.75859398 0.656977 0.75826299 0.662094 0.75727999 0.66713899 0.714019 0.66713899
		 0.91366601 0.439316 0.92072898 0.439316 0.92072898 0.47093299 0.91366601 0.47093299
		 0.0099999998 0.812635 0.0099999998 0.71782303 0.018193001 0.72564501 0.023267999
		 0.729922 0.029410001 0.72564501 0.058189001 0.70216 0.064799003 0.70147002 0.064799003
		 0.812635 0.69750702 0.049810998 0.69750702 0.0099999998 0.729123 0.0099999998 0.729123
		 0.053261001 0.72531003 0.052965 0.71961099 0.052322 0.70516199 0.045327 0.62993503
		 0.25317901 0.62993503 0.25978601 0.56869602 0.25978601 0.57146001 0.25429201 0.571455
		 0.25317901 0.4199703 -0.62578762 0.40577748 -0.62578762 0.40618226 -0.61485833 0.4199703
		 -0.61485833 0.4353601 -0.61485833 0.43492705 -0.62578762 0.4199703 -0.56727195 0.43630245
		 -0.59852618 0.42248207 -0.55711699 0.44654462 -0.55711699 0.4199703 -0.54872543 0.4199703
		 -0.53517812 0.43997824 -0.53517812 0.41537812 -0.53517812 0.85362202 0.90332001 0.85362202
		 0.88364398 0.86203802 0.88364398 0.86203802 0.90332001 0.69920498 0.80408502 0.76197201
		 0.80408502 0.76197201 0.80993497 0.70122898 0.80993497 0.35525501 0.39183399 0.35525501
		 0.27269399 0.404324 0.27269399 0.404324 0.381484 0.382725 0.37630001 0.37918401 0.37797901
		 0.91908002 0.069335997 0.91908002 0.123862 0.91066402 0.123862 0.91066402 0.076087996
		 0.917979 0.072208002 0.74854398 0.58961201 0.74854398 0.547396 0.77685499 0.547396
		 0.77685499 0.60192102 0.77543402 0.59906298 0.76055199 0.59307402 0.74953902 0.58944601
		 0.27097744 -0.3348015 0.27669382 -0.35390234 0.29077923 -0.35567153 0.29032308 -0.35414717
		 0.29013598 -0.33039469 0.27094278 -0.33039469 0.28838992 -0.29447263 0.27160564 -0.29935178
		 0.29085082 -0.29693356 0.29295436 -0.29086322;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 48 ".vt[0:47]"  -1.20618296 28.90206146 -32.55166245 -37.53705215 28.90206146 -32.55166245
		 -37.53705215 28.90206146 -37.53705215 2.13294101 28.90206146 -37.53705215 -5.49213982 44.41249466 -32.55166245
		 -37.53705215 44.41249466 -32.55166245 -1.19415104 29.20428658 -32.55166245 -1.68394101 36.75340271 -32.55166245
		 -2.74528503 39.091411591 -32.55166245 -37.53705215 44.41249466 -37.53705215 -5.89792824 44.41249466 -37.53705215
		 -2.38770103 41.72353363 -37.53705215 -1.26708603 39.55273056 -37.53705215 2.06223011 32.21866226 -37.53705215
		 2.18788099 30.28201294 -37.53705215 -4.78982019 44.41249466 -34.59166336 -37.53705215 7.20095301 -37.53705215
		 -6.072668076 7.20095301 -37.53705215 -6.30647278 7.20095301 -35.026920319 -7.00025320053 7.20095301 -32.55166245
		 -37.53705215 7.20095301 -32.55166245 -37.53705215 22.71138573 -32.55166245 -37.53705215 22.71138573 -37.53705215
		 -10.70102882 22.71138573 -37.53705215 -12.91499233 20.39240265 -37.53705215 -14.12580204 18.95588303 -37.53705215
		 -12.91499233 17.21757698 -37.53705215 -6.26795292 9.071750641 -37.53705215 -9.43526745 22.71138573 -32.55166245
		 -7.20894384 9.071750641 -32.55166245 -7.66331577 11.86749935 -32.55166245 -12.60069656 18.95588303 -32.55166245
		 -10.70339298 22.71138573 -36.69701385 -6.49508476 9.071750641 -35.098560333 -37.80400848 5.99207687 -41.94765854
		 -23.9174118 5.74968576 -41.94765854 -23.9174118 5.74968576 -37.81857681 -37.80400848 5.99207687 -37.81857681
		 -37.26660538 36.77983093 -41.94765854 -37.28393936 35.78672791 -37.81857681 -23.32888222 39.46653748 -41.94765854
		 -31.17988586 35.20610046 -41.94765854 -30.16941452 35.6636734 -41.94765854 -23.24570274 44.2318306 -37.81857681
		 -23.28107262 42.20550919 -38.35919571 -23.97802544 42.22668457 -37.81857681 -31.35150337 38.12753677 -37.81857681
		 -36.79815292 35.66112518 -37.81857681;
	setAttr -s 73 ".ed[0:72]"  0 1 0 1 2 0 2 3 0 3 0 0 4 5 0 5 1 0 0 6 0
		 6 7 0 7 8 0 8 4 0 5 9 0 9 2 0 9 10 0 10 11 0 11 12 0 12 13 0 13 14 0 14 3 0 4 15 0
		 15 10 0 14 6 0 13 7 0 12 8 0 11 15 0 16 17 0 17 18 0 18 19 0 19 20 0 20 16 0 21 22 0
		 22 16 0 20 21 0 22 23 0 23 24 0 24 25 0 25 26 0 26 27 0 27 17 0 28 21 0 19 29 0 29 30 0
		 30 31 0 31 28 0 28 32 0 32 23 0 27 33 0 33 18 0 33 29 0 26 33 0 33 30 0 25 31 0 24 32 0
		 34 35 0 35 36 0 36 37 0 37 34 0 38 34 0 37 39 0 39 38 0 40 35 0 38 41 0 41 42 0 42 40 0
		 43 36 0 40 44 0 44 43 0 43 45 0 45 46 0 46 47 0 47 39 0 47 41 0 46 42 0 45 44 0;
	setAttr -s 146 ".n[0:145]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 0 -1 0
		 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0
		 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.82312697
		 0.037896998 0.56659198 0.83039999 -0.033059999 0.55618602 0.83039999 -0.033059999
		 0.55618602 0.82248598 0.042647 0.56718397 0.87365597 0.304849 0.379199 0.82312697
		 0.037896998 0.56659198 0.82248598 0.042647 0.56718397 0.84814698 0.13851 0.511334
		 0.84814698 0.13851 0.511334 0.86096197 0.415306 0.29371101 0.86039197 0.41652599
		 0.29365399 0.87365597 0.304849 0.379199 0.84971601 0.43864101 0.29253501 0.84971601
		 0.43864101 0.29253501 0.86039197 0.41652599 0.29365399 0.86096197 0.415306 0.29371101
		 0.84971601 0.43864101 0.29253501 0.59280002 0.77385402 -0.223021 0.59280002 0.77385402
		 -0.223021 0.59280002 0.77385402 -0.223021 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0
		 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.977193 0.105575
		 0.18425 0.99035501 0.10338 0.092246003 0.99035501 0.10338 0.092246003 0.97394902
		 0.113716 0.196196 0.95496303 0.128069 0.267663 0.95738602 0.106798 0.268341 0.977193
		 0.105575 0.18425 0.97394902 0.113716 0.196196 0.77277303 0.63058698 0.07198 0.79627401
		 0.556701 -0.236711 0.79789799 0.58313501 -0.152684 0.95131397 0.15460999 0.26664001
		 0.95496303 0.128069 0.267663 0.97394902 0.113716 0.196196 0.79789799 0.58313501 -0.152684
		 0.79627401 0.556701 -0.236711 0.79587001 0.55435997 -0.243469 0.79587001 0.55435902
		 -0.243469 0.79587001 0.55435902 -0.243469 0.744524 -0.62754202 -0.227761 0.744524
		 -0.62794697 -0.226643 0.74449998 -0.630391 -0.219833 0.744524 -0.62754202 -0.227761
		 0.744524 -0.62754202 -0.227761 0.744524 -0.62794697 -0.226643 0.72329301 -0.69053799
		 0.0020339999 0.74449998 -0.630391 -0.219833 -0.017452 -0.99984801 0 -0.017452 -0.99984801
		 0 -0.017452 -0.99984801 0 -0.017452 -0.99984801 0 -0.99984801 0.017452 0 -0.99984801
		 0.017452 0 -0.99984801 0.017452 0 -0.99984801 0.017452 0 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 -1 0 0 -1 0.99984801 -0.017452 0 0.99984801 -0.017452 0 0.99984801 -0.017452
		 0 0.99984801 -0.017452 0 0.99984801 -0.017452 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0
		 1 0 0 1 0.24374101 0.94271702 0.227761 0.24374101 0.94271702 0.227761 0.24374101
		 0.94271702 0.227761 0.24374101 0.94271702 0.227761 -0.344019 0.75970697 -0.55181199
		 -0.38766801 0.73850501 -0.55165601 -0.38733 0.73867798 -0.55166203 -0.344019 0.75970697
		 -0.55181199 -0.40541199 0.72925001 -0.55121303 -0.40541199 0.72925001 -0.55121303
		 -0.38733 0.73867798 -0.55166203 -0.38766801 0.73850501 -0.55165601 -0.40541199 0.72925001
		 -0.55121303 -0.594181 0.21700799 -0.77450401 -0.594181 0.21700799 -0.77450401 -0.594181
		 0.21700799 -0.77450401;
	setAttr -s 31 -ch 146 ".fc[0:30]" -type "polyFaces" 
		f 4 0 1 2 3
		mu 0 4 0 1 2 3
		f 7 4 5 -1 6 7 8 9
		mu 0 7 4 5 6 7 8 9 10
		f 4 10 11 -2 -6
		mu 0 4 11 12 13 14
		f 8 12 13 14 15 16 17 -3 -12
		mu 0 8 15 16 17 18 19 20 21 22
		f 5 -11 -5 18 19 -13
		mu 0 5 23 24 25 26 27
		f 4 -7 -4 -18 20
		mu 0 4 28 29 30 31
		f 4 -8 -21 -17 21
		mu 0 4 32 28 31 33
		f 4 -16 22 -9 -22
		mu 0 4 33 34 35 32
		f 5 -19 -10 -23 -15 23
		mu 0 5 36 37 35 34 38
		f 3 -14 -20 -24
		mu 0 3 38 39 36
		f 5 24 25 26 27 28
		mu 0 5 40 41 42 43 44
		f 4 29 30 -29 31
		mu 0 4 45 46 47 48
		f 8 32 33 34 35 36 37 -25 -31
		mu 0 8 49 50 51 52 53 54 55 56
		f 7 38 -32 -28 39 40 41 42
		mu 0 7 57 58 59 60 61 62 63
		f 5 -30 -39 43 44 -33
		mu 0 5 64 65 66 67 68
		f 4 -26 -38 45 46
		mu 0 4 69 70 71 72
		f 4 -40 -27 -47 47
		mu 0 4 73 74 69 72
		f 3 -37 48 -46
		mu 0 3 71 75 72
		f 3 -41 -48 49
		mu 0 3 76 73 72
		f 5 -49 -36 50 -42 -50
		mu 0 5 72 75 77 78 76
		f 5 -35 51 -44 -43 -51
		mu 0 5 77 79 80 81 78
		f 3 -34 -45 -52
		mu 0 3 79 82 80
		f 4 52 53 54 55
		mu 0 4 83 84 85 86
		f 4 56 -56 57 58
		mu 0 4 87 88 89 90
		f 6 59 -53 -57 60 61 62
		mu 0 6 91 92 93 94 95 96
		f 5 63 -54 -60 64 65
		mu 0 5 97 98 99 100 101
		f 7 -58 -55 -64 66 67 68 69
		mu 0 7 102 103 104 105 106 107 108
		f 4 -61 -59 -70 70
		mu 0 4 109 110 111 112
		f 4 -69 71 -62 -71
		mu 0 4 112 113 114 109
		f 5 -65 -63 -72 -68 72
		mu 0 5 115 116 114 113 117
		f 3 -67 -66 -73
		mu 0 3 117 118 115;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh10" -p "breakingcrate_geo";
	rename -uid "0A096F4E-4EEB-3924-260C-6F85F2B01303";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" -6.5793962478637695 58.130420684814453 -36.956401824951172 ;
	setAttr ".sp" -type "double3" -6.5793962478637695 58.130420684814453 -36.956401824951172 ;
createNode mesh -n "breakingcrate_mesh10Shape" -p "breakingcrate_mesh10";
	rename -uid "5E830E21-4F1D-7AA0-F9E9-B68A4E9B51AE";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh10ShapeOrig" -p "breakingcrate_mesh10";
	rename -uid "E51ABE46-4F63-6312-B84F-73959D8446FB";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 152 ".uvst[0].uvsp[0:151]" -type "float2" 0.404324 0.53793299
		 0.35525501 0.53793299 0.35525501 0.39183399 0.37918401 0.37797901 0.382725 0.37630001
		 0.404324 0.381484 0.70122898 0.80993497 0.60894102 0.80993497 0.60894102 0.80408502
		 0.69920498 0.80408502 0.85828698 0.34324601 0.85828698 0.35166201 0.83861101 0.35166201
		 0.83861101 0.34324601 0.91066402 0.017506 0.91908002 0.017506 0.91908002 0.069335997
		 0.917979 0.072208002 0.91066402 0.076087996 0.77685499 0.65375203 0.74854398 0.65375203
		 0.74854398 0.58961201 0.74953902 0.58944601 0.76055199 0.59307402 0.77543402 0.59906298
		 0.77685499 0.60192102 0.3329823 -0.43497518 0.33343846 -0.43649954 0.31935304 -0.43473035
		 0.31363666 -0.41562951 0.313602 -0.4112227 0.3327952 -0.4112227 0.31426486 -0.38017979
		 0.33104914 -0.37530065 0.33351004 -0.37776157 0.33561358 -0.37169123 0.85662401 0.74816
		 0.85662401 0.70081103 0.85853797 0.70016497 0.86612999 0.70232499 0.86612999 0.74816
		 0.97070801 0.83560902 0.98087001 0.83560902 0.98087001 0.85758197 0.97070801 0.85758197
		 0.0099999998 0.54393703 0.0099999998 0.44795299 0.014275 0.44586301 0.026388001 0.44115201
		 0.053587001 0.45017201 0.064799003 0.43348101 0.064799003 0.54393703 0.67221999 0.181126
		 0.69878501 0.181126 0.69878501 0.212743 0.65591103 0.212743 0.65897602 0.205512 0.65945101
		 0.205054 0.65925097 0.20418499 0.66415101 0.186056 0.66426498 0.185721 0.66508597
		 0.185258 0.715298 0.79057503 0.715298 0.80073798 0.68873298 0.80073798 0.68529302
		 0.79920101 0.68036997 0.79711801 0.67681003 0.79057503 0.47322285 -0.64843667 0.47120306
		 -0.67235887 0.44669878 -0.67496067 0.44218975 -0.67391902 0.44991499 -0.64649189
		 0.47377023 -0.64649189 0.43891004 -0.61023492 0.47316164 -0.64448595 0.43925303 -0.58875054
		 0.47405142 -0.58875054 0.43963122 -0.58090585 0.46227914 -0.57586265 0.47410226 -0.58768582
		 0.47516757 -0.56847584 0.47516757 -0.58520174 0.484386 -0.56332123 0.52428901 0.82510102
		 0.52428901 0.84477699 0.51587301 0.84477699 0.51587301 0.82510102 0.66251397 0.439504
		 0.61344498 0.439504 0.61344498 0.27269399 0.66251397 0.27269399 0.97371 0.35525501
		 0.98212701 0.35525501 0.98212701 0.422142 0.97371 0.422142 0.83861101 0.27269399
		 0.86692101 0.27269399 0.86692101 0.339582 0.83861101 0.339582 0.88364398 0.137004
		 0.88364398 0.12858699 0.95053202 0.12858699 0.95053202 0.137004 0.65381998 0.47213
		 0.64797002 0.47213 0.64797002 0.44382 0.65381998 0.44382 0.86713201 0.456945 0.86713201
		 0.40843001 0.86741501 0.40870899 0.876638 0.40785399 0.87663698 0.456945 0.98667699
		 0.53538698 0.98667699 0.54554999 0.96470398 0.54554999 0.96470398 0.53538698 0.068543002
		 0.812635 0.068543002 0.65705502 0.083039001 0.66874301 0.087590002 0.67221498 0.1081
		 0.69032198 0.117194 0.69104898 0.122944 0.699579 0.123342 0.699458 0.123342 0.812635
		 0.66598397 0.43883601 0.66598397 0.382274 0.69760001 0.382274 0.69760001 0.428195
		 0.69439602 0.43149799 0.67750603 0.432437 0.67404199 0.43456301 0.73931599 0.25317901
		 0.73931599 0.26334101 0.68275398 0.26334101 0.68110299 0.26032999 0.67693001 0.25317901
		 0.49100891 -0.38294983 0.48985755 -0.3824631 0.49002674 -0.38196707 0.51354074 -0.36710793
		 0.51637989 -0.3814584 0.48708713 -0.36710793 0.52008861 -0.32218689 0.48912078 -0.35315418
		 0.48508582 -0.30936658 0.51890725 -0.30936658 0.50681156 -0.2777226 0.51703584 -0.28080195
		 0.48447606 -0.30005813 0.48220453 -0.2699402;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 60 ".vt[0:59]"  -36.49378204 81.054740906 -41.94765854 -22.60718727 80.81235504 -41.94765854
		 -23.32888222 39.46653748 -41.94765854 -30.16941452 35.6636734 -41.94765854 -31.17988586 35.20610046 -41.94765854
		 -37.26660538 36.77983093 -41.94765854 -37.28393936 35.78672791 -37.81857681 -36.49378204 81.054740906 -37.81857681
		 -22.60718727 80.81235504 -37.81857681 -23.24570274 44.2318306 -37.81857681 -23.28107262 42.20550919 -38.35919571
		 -36.79815292 35.66112518 -37.81857681 -31.35150337 38.12753677 -37.81857681 -23.97802544 42.22668457 -37.81857681
		 -37.53705215 44.73800659 -36.95053482 -6.27325296 44.73800659 -36.95053482 -5.84713221 44.73800659 -35.94696808
		 -7.27307796 44.73800659 -31.96514511 -37.53705215 44.73800659 -31.96514511 -37.53705215 60.24843597 -31.96514511
		 -37.53705215 60.24843597 -36.95053482 -10.36940289 60.24843597 -36.95053482 -9.77772808 59.038318634 -36.95053482
		 -8.44431782 55.60993958 -36.95053482 -10.99748611 47.91139221 -36.95053482 -18.78546524 60.24843597 -31.96514511
		 -9.43691063 48.28504562 -31.96514511 -9.77188683 48.51005936 -31.96514511 -9.63064194 48.93595123 -31.96514511
		 -13.089850426 57.83004761 -31.96514511 -13.17016983 57.99431992 -31.96514511 -13.74949074 58.22135925 -31.96514511
		 -16.3578701 60.24843597 -32.71890259 -12.88234901 60.24843597 -33.74060822 24.37825966 60.577034 -40.77462387
		 23.65138054 74.44670105 -40.77462387 23.65138054 74.44670105 -36.64554596 24.37825966 60.577034 -36.64554596
		 -22.77160645 58.10601425 -40.77462387 -23.49848557 71.97568512 -40.77462387 -23.49848557 71.97568512 -36.64554596
		 -22.77160645 58.10601425 -36.64554596 -37.53705215 63.21327209 -37.53705215 -5.50301886 63.21327209 -37.53705215
		 -5.68710184 63.21327209 -37.38856125 -5.12265921 63.21327209 -32.55166245 -37.53705215 63.21327209 -32.55166245
		 -37.53705215 78.72370148 -32.55166245 -37.53705215 78.72370148 -37.53705215 6.49893093 78.72370148 -37.53705215
		 3.19071388 74.6207962 -37.53705215 2.20788693 73.3325882 -37.53705215 -2.91721392 67.5273056 -37.53705215
		 -3.12303805 64.95353699 -37.53705215 -5.53739405 63.32588196 -37.53705215 2.3881011 78.72370148 -32.55166245
		 -2.7910161 64.78516388 -32.55166245 -2.128407 73.070930481 -32.55166245 -0.62786698 74.77061462 -32.55166245
		 3.55357504 78.72370148 -34.029037476;
	setAttr -s 90 ".ed[0:89]"  0 1 0 1 2 0 2 3 0 3 4 0 4 5 0 5 0 0 6 7 0
		 7 0 0 5 6 0 7 8 0 8 1 0 8 9 0 9 10 0 10 2 0 6 11 0 11 12 0 12 13 0 13 9 0 4 11 0
		 3 12 0 10 13 0 14 15 0 15 16 0 16 17 0 17 18 0 18 14 0 19 20 0 20 14 0 18 19 0 20 21 0
		 21 22 0 22 23 0 23 24 0 24 15 0 25 19 0 17 26 0 26 27 0 27 28 0 28 29 0 29 30 0 30 31 0
		 31 25 0 25 32 0 32 33 0 33 21 0 16 26 0 24 27 0 23 28 0 22 29 0 33 30 0 32 31 0 34 35 0
		 35 36 0 36 37 0 37 34 0 38 39 0 39 35 0 34 38 0 39 40 0 40 36 0 40 41 0 41 37 0 41 38 0
		 42 43 0 43 44 0 44 45 0 45 46 0 46 42 0 47 48 0 48 42 0 46 47 0 48 49 0 49 50 0 50 51 0
		 51 52 0 52 53 0 53 54 0 54 43 0 55 47 0 45 56 0 56 57 0 57 58 0 58 55 0 55 59 0 59 49 0
		 54 44 0 53 56 0 52 57 0 51 58 0 50 59 0;
	setAttr -s 180 ".n";
	setAttr ".n[0:165]" -type "float3"  0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0
		 0 -1 -0.99984801 0.017452 0 -0.99984801 0.017452 0 -0.99984801 0.017452 0 -0.99984801
		 0.017452 0 0.017452 0.99984801 0 0.017452 0.99984801 0 0.017452 0.99984801 0 0.017452
		 0.99984801 0 0.99984801 -0.017452 0 0.99984801 -0.017452 0 0.99984801 -0.017452 0
		 0.99984801 -0.017452 0 0.99984801 -0.017452 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1
		 0 0 1 -0.24374101 -0.94271702 -0.227761 -0.24374101 -0.94271702 -0.227761 -0.24374101
		 -0.94271702 -0.227761 -0.24374101 -0.94271702 -0.227761 0.344019 -0.75970697 0.55181199
		 0.38733 -0.73867798 0.55166203 0.38766801 -0.73850501 0.55165601 0.344019 -0.75970697
		 0.55181199 0.38733 -0.73867798 0.55166203 0.40541199 -0.72925001 0.55121303 0.40541199
		 -0.72925001 0.55121303 0.40541199 -0.72925001 0.55121303 0.38766801 -0.73850501 0.55165601
		 0.594181 -0.21700799 0.77450401 0.594181 -0.21700799 0.77450401 0.594181 -0.21700799
		 0.77450401 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1
		 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0
		 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.81638902 0.49803001 0.29236099
		 0.81638902 0.49803001 0.29236099 0.81638902 0.49803001 0.29236099 0.54260302 0.80777502
		 -0.23039401 0.54260302 0.80777502 -0.23039401 0.54260302 0.80777502 -0.23039401 0.54260302
		 0.80777502 -0.23039401 0.54260302 0.80777502 -0.23039401 0.93152201 -0.30893299 -0.19190601
		 0.93152201 -0.30893299 -0.19190601 0.93152201 -0.30893299 -0.19190601 0.93152201
		 -0.30893299 -0.19190601 0.760993 0.29597601 0.57731098 0.756428 0.30777901 0.57713902
		 0.75606799 0.30869499 0.57712102 0.760993 0.29597601 0.57731098 0.756428 0.30777901
		 0.57713902 0.734828 0.35928699 0.57527399 0.734828 0.35928699 0.57527399 0.734828
		 0.35928699 0.57527399 0.75606799 0.30869499 0.57712102 0.228918 0.584126 0.77871299
		 0.235038 0.58973801 0.772636 0.22961099 0.584764 0.77802998 0.228917 0.584126 0.77871299
		 0.235038 0.58973801 0.772636 0.23874301 0.593117 0.76890498 0.22961099 0.584764 0.77802998
		 0.99862999 0.052336 0 0.99862999 0.052336 0 0.99862999 0.052336 0 0.99862999 0.052336
		 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 -0.052336 0.99862999 0 -0.052336 0.99862999 0 -0.052336
		 0.99862999 0 -0.052336 0.99862999 0 0 0 1 0 0 1 0 0 1 0 0 1 0.052336 -0.99862999
		 0 0.052336 -0.99862999 0 0.052336 -0.99862999 0 0.052336 -0.99862999 0 -0.99862999
		 -0.052336 0 -0.99862999 -0.052336 0 -0.99862999 -0.052336 0 -0.99862999 -0.052336
		 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0
		 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.61663699 0.188228 0.76441401 0.61663699 0.188228
		 0.76441401 0.61663699 0.188228 0.76441401 0.55780703 -0.82741398 -0.065094002 0.55780703
		 -0.82741398 -0.065094002 0.55780703 -0.82741398 -0.065094002 0.55780703 -0.82741398
		 -0.065094002 0.55780703 -0.82741398 -0.065094002 0.99444801 -0.079526 -0.068915002
		 0.99444801 -0.079526 -0.068915002;
	setAttr ".n[166:179]" -type "float3"  0.99444801 -0.079526 -0.068915002 0.99444801
		 -0.079526 -0.068915002 0.63790202 -0.56316203 0.52529103 0.65553701 -0.53943002 0.528476
		 0.65290898 -0.54304701 0.52802402 0.63790202 -0.56316203 0.52529103 0.669231 -0.51618397
		 0.53449398 0.67352498 -0.51385897 0.531331 0.65290898 -0.54304701 0.52802402 0.65553701
		 -0.53943002 0.528476 0.67021501 -0.51565403 0.53377199 0.67021501 -0.51565403 0.53377199
		 0.65162498 -0.52541101 0.54710901 0.669231 -0.51618397 0.53449398;
	setAttr -s 38 -ch 180 ".fc[0:37]" -type "polyFaces" 
		f 6 0 1 2 3 4 5
		mu 0 6 0 1 2 3 4 5
		f 4 6 7 -6 8
		mu 0 4 6 7 8 9
		f 4 -8 9 10 -1
		mu 0 4 10 11 12 13
		f 5 -11 11 12 13 -2
		mu 0 5 14 15 16 17 18
		f 7 -10 -7 14 15 16 17 -12
		mu 0 7 19 20 21 22 23 24 25
		f 4 -15 -9 -5 18
		mu 0 4 26 27 28 29
		f 4 -4 19 -16 -19
		mu 0 4 29 30 31 26
		f 5 -3 -14 20 -17 -20
		mu 0 5 30 32 33 34 31
		f 3 -13 -18 -21
		mu 0 3 33 35 34
		f 5 21 22 23 24 25
		mu 0 5 36 37 38 39 40
		f 4 26 27 -26 28
		mu 0 4 41 42 43 44
		f 7 29 30 31 32 33 -22 -28
		mu 0 7 45 46 47 48 49 50 51
		f 10 34 -29 -25 35 36 37 38 39 40 41
		mu 0 10 52 53 54 55 56 57 58 59 60 61
		f 6 -27 -35 42 43 44 -30
		mu 0 6 62 63 64 65 66 67
		f 3 -36 -24 45
		mu 0 3 68 69 70
		f 5 -23 -34 46 -37 -46
		mu 0 5 70 71 72 73 68
		f 4 -33 47 -38 -47
		mu 0 4 72 74 75 73
		f 4 -32 48 -39 -48
		mu 0 4 74 76 77 75
		f 5 -31 -45 49 -40 -49
		mu 0 5 76 78 79 80 77
		f 4 -44 50 -41 -50
		mu 0 4 79 81 82 80
		f 3 -43 -42 -51
		mu 0 3 81 83 82
		f 4 51 52 53 54
		mu 0 4 84 85 86 87
		f 4 55 56 -52 57
		mu 0 4 88 89 90 91
		f 4 58 59 -53 -57
		mu 0 4 92 93 94 95
		f 4 60 61 -54 -60
		mu 0 4 96 97 98 99
		f 4 62 -58 -55 -62
		mu 0 4 100 101 102 103
		f 4 -63 -61 -59 -56
		mu 0 4 104 105 106 107
		f 5 63 64 65 66 67
		mu 0 5 108 109 110 111 112
		f 4 68 69 -68 70
		mu 0 4 113 114 115 116
		f 9 71 72 73 74 75 76 77 -64 -70
		mu 0 9 117 118 119 120 121 122 123 124 125
		f 7 78 -71 -67 79 80 81 82
		mu 0 7 126 127 128 129 130 131 132
		f 5 -69 -79 83 84 -72
		mu 0 5 133 134 135 136 137
		f 3 -65 -78 85
		mu 0 3 138 139 140
		f 5 -80 -66 -86 -77 86
		mu 0 5 141 142 138 140 143
		f 4 -81 -87 -76 87
		mu 0 4 144 141 143 145
		f 4 -75 88 -82 -88
		mu 0 4 145 146 147 144
		f 5 -84 -83 -89 -74 89
		mu 0 5 148 149 147 146 150
		f 3 -73 -85 -90
		mu 0 3 150 151 148;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh11" -p "breakingcrate_geo";
	rename -uid "C0104B73-4783-9764-9623-05B9BBEFD35A";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" -9.5819339752197266 82.25341796875 -0.0014324188232421875 ;
	setAttr ".sp" -type "double3" -9.5819339752197266 82.25341796875 -0.0014324188232421875 ;
createNode mesh -n "breakingcrate_mesh11Shape" -p "breakingcrate_mesh11";
	rename -uid "9A390E84-421E-1FE8-4CD5-86B975FFAB88";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh11ShapeOrig" -p "breakingcrate_mesh11";
	rename -uid "500C9AAE-430E-0346-9D5F-34AB6DE42524";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 231 ".uvst[0].uvsp[0:230]" -type "float2" 0.73009199 0.86381102
		 0.73009199 0.91833401 0.69900799 0.91833401 0.69900799 0.84190297 0.71415198 0.84886903
		 0.71553499 0.85051298 0.72739601 0.86407 0.72974497 0.86394799 0.90255201 0.94692701
		 0.96039599 0.954346 0.96013099 0.961335 0.90495199 0.95425802 0.90450603 0.95262402
		 0.503425 0.243108 0.472341 0.243108 0.472341 0.238168 0.503425 0.238168 0.91804498
		 0.62505603 0.84161299 0.62505603 0.84161299 0.617948 0.91774797 0.617948 0.082592003
		 0.93167901 0.27246201 0.93167901 0.27246201 0.98555601 0.129921 0.98555601 0.131082
		 0.97000402 0.110612 0.95755601 0.092845 0.94717199 0.35672677 -0.40495637 0.30595428
		 -0.40495637 0.30638903 -0.38458696 0.33635679 -0.38458696 0.36283985 -0.38458696
		 0.36283985 -0.40495637 0.41446814 -0.40495637 0.39409873 -0.38458696 0.42058122 -0.40495637
		 0.41745627 -0.38458696 0.42058122 -0.4003827 0.42131221 -0.40495637 0.75635201 0.94971597
		 0.69900799 0.94971597 0.69900799 0.92267299 0.75356698 0.92267299 0.76216298 0.94498301
		 0.76126897 0.94677103 0.937684 0.684241 0.937684 0.63445997 0.94479102 0.63445997
		 0.94479102 0.69180399 0.53991401 0.514808 0.51287103 0.514808 0.51287103 0.50986803
		 0.53991401 0.50986803 0.93962097 0.216524 0.93962097 0.29502699 0.93468201 0.29502699
		 0.93468201 0.21334 0.396575 0.92567497 0.53815901 0.92567497 0.53815901 0.97254801
		 0.41401201 0.97254801 0.39262801 0.96364498 0.38296801 0.950221 0.45183951 -0.38458696
		 0.47832257 -0.38458696 0.47832257 -0.40495637 0.47220948 -0.40495637 0.42551231 -0.40495637
		 0.42219737 -0.38458696 0.50488013 -0.38458696 0.49355185 -0.40495637 0.53043699 0.79851699
		 0.508367 0.79851699 0.508367 0.79357803 0.53043699 0.79357803 0.95070601 0.439316
		 0.95089 0.49564201 0.94386297 0.49296999 0.94368798 0.43952101 0.81609398 0.59985602
		 0.83816397 0.60302001 0.83816397 0.65263897 0.81609398 0.65263897 0.96730798 0.81467599
		 0.96020001 0.81751698 0.96020001 0.76505703 0.96730798 0.76505703 0.56691098 0.67902899
		 0.60516298 0.67114002 0.60516298 0.80985802 0.56691098 0.80985802 0.47235066 -0.60411304
		 0.47450668 -0.58281511 0.41567343 -0.58281511 0.41351736 -0.60411304 0.76762003 0.229131
		 0.76762003 0.248841 0.73653603 0.248841 0.73653603 0.181991 0.738437 0.177793 0.74493802
		 0.18473101 0.74967003 0.20634601 0.75550902 0.22397199 0.76120502 0.22548801 0.76676798
		 0.22958601 0.93256903 0.75375301 0.933617 0.78588802 0.92867702 0.78588802 0.92867702
		 0.75752801 0.93210799 0.75274599 0.53644902 0.85555899 0.50536501 0.85555899 0.50536501
		 0.85061997 0.53644902 0.85061997 0.94403601 0.25037301 0.94382101 0.184462 0.94624901
		 0.18214899 0.949103 0.17840999 0.95083302 0.182475 0.95105398 0.25016901 0.933617
		 0.74965698 0.93279397 0.754246 0.93352002 0.74999201 0.24117 0.709723 0.24117 0.547396
		 0.29504699 0.547396 0.29504699 0.61019301 0.29324299 0.61016601 0.27648601 0.61810702
		 0.27370399 0.622437 0.25850201 0.69040197 0.254917 0.68769097 0.251147 0.69419599
		 0.32433444 -0.3353405 0.32444191 -0.33699131 0.32466185 -0.34036517 0.32968652 -0.3353405
		 0.32441011 -0.33006412 0.32541019 -0.36539775 0.32968652 -0.3652055 0.32968652 -0.32912642
		 0.32440323 -0.32935679 0.35835278 -0.36400679 0.37909752 -0.32701015 0.38742787 -0.3353405
		 0.38742787 -0.36275727 0.38742787 -0.32666892 0.41889921 -0.36161053 0.44516921 -0.3353405
		 0.43478155 -0.32495284 0.44516921 -0.36074209 0.44516921 -0.32448572 0.47889131 -0.35935977
		 0.48814493 -0.35010612 0.48712754 -0.3353405 0.4564842 -0.32402551 0.48635149 -0.32280198
		 0.48810858 -0.35890362 0.73309398 0.20343401 0.73309398 0.248841 0.70200998 0.248841
		 0.70200998 0.211007 0.71005797 0.20318399 0.71059901 0.203596 0.728715 0.212189 0.72914797
		 0.212265 0.955697 0.053192001 0.955697 0.017506 0.96280497 0.017506 0.96280497 0.062912002
		 0.959203 0.053286999 0.330798 0.243108 0.299714 0.243108 0.299714 0.238168 0.330798
		 0.238168 0.93492299 0.59294999 0.93483597 0.53750497 0.93580502 0.53307098 0.93971401
		 0.53753197 0.93980098 0.59265602 0.177561 0.87463701 0.27246201 0.87463701 0.27246201
		 0.928514 0.183465 0.928514 0.181567 0.92103797 0.170302 0.90453303 0.150943 0.88687599
		 0.165849 0.87621897 0.34782422 -0.39317414 0.33648556 -0.40669486 0.36134437 -0.40669486
		 0.36283985 -0.40669486 0.36283985 -0.3800149 0.34793624 -0.3800149 0.41908628 -0.40669486
		 0.39240575 -0.3800149 0.42058122 -0.40669486 0.42058122 -0.3800149 0.45928121 -0.40669486
		 0.45548412 -0.38535133 0.45014709 -0.3800149 0.45902193 -0.3800149 0.71852201 0.68099499
		 0.74960601 0.68099499 0.74960601 0.75123698 0.74960601 0.78623801 0.71852201 0.78623801
		 0.53644902 0.82103401 0.50536501 0.82103401 0.50536501 0.81609398 0.53644902 0.81609398
		 0.961303 0.47431701 0.961303 0.544559 0.95419598 0.544559 0.95419598 0.474879 0.95419598
		 0.439316 0.961303 0.439316 0.94218701 0.32973599 0.94929498 0.32973599 0.94929498
		 0.43497801 0.94218701 0.43497801 0.184236 0.86924201 0.01047 0.870758 0.0099999998
		 0.81688303 0.272452 0.81459302 0.27292201 0.86846799 0.61344498 0.44382 0.64452899
		 0.44382 0.64452899 0.44876 0.61344498 0.44876;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 93 ".vt[0:92]"  1.92891395 78.75595856 -22.14099503 -36.55757141 78.75595856 -22.14099503
		 -36.55757141 78.75595856 -37.39042282 17.39370346 78.75595856 -37.39042282 12.4766922 78.75595856 -29.96102524
		 11.31582737 78.75595856 -29.28253365 1.74639904 78.75595856 -23.46362114 1.83242905 78.75595856 -22.31151962
		 3.78783393 82.24280548 -22.14099503 -36.55757141 82.24280548 -22.14099503 2.28137302 79.53890228 -22.14099503
		 -36.55757141 82.24280548 -37.39042282 17.18405914 82.24280548 -37.39042282 3.45912504 82.24280548 -26.54297829
		 9.25298595 82.24280548 -30.066068649 14.2818327 82.24280548 -33.005279541 4.56422091 78.75595856 -7.91212177
		 -35.91175079 78.75595856 -7.55889416 -36.027526855 78.75595856 -20.82539177 2.48314404 78.75595856 -21.16146851
		 8.64575481 78.75595856 -10.26989269 8.0222826 78.75595856 -9.38728237 -0.774185 82.24280548 -7.86553478
		 -35.91175079 82.24280548 -7.55889416 -36.027526855 82.24280548 -20.82539177 4.045114994 82.24280548 -21.17510033
		 5.25610018 82.24280548 -10.43796825 7.95697308 82.24280548 -14.26142216 -36.55757141 78.75595856 -6.73320913
		 -36.55757141 82.24280548 -6.73320913 -36.55757141 78.75595856 4.093883991 -36.55757141 82.24280548 4.093883991
		 -1.53275299 78.75595856 4.093883991 0.70036697 78.75595856 -6.73320913 0.472664 82.24280548 4.093883991
		 2.70578408 82.24280548 -6.73320913 -21.37027931 78.45167542 19.68798447 -35.27814484 78.46755981 19.32414055
		 -34.87895966 79.13249969 4.094446182 12.29288387 79.078620911 5.3285079 15.23044872 79.034561157 6.33757305
		 10.25146675 78.90109253 9.3944912 -5.061467171 78.817276 11.31431007 -17.57398605 78.70658112 13.84965038
		 -18.71692657 78.58595276 16.61245155 -21.67995262 78.47026062 19.26232529 -19.51883888 81.19384766 19.8562355
		 -35.27814484 81.95108795 19.47623253 -19.02507782 80.86811829 19.85495567 -34.87895966 82.61602783 4.24654007
		 11.050835609 82.56356812 5.44810915 12.61313248 81.35318756 5.43621206 15.1602354 79.92783356 5.44074202
		 -17.50988007 81.93079376 19.94106865 -19.76037979 81.35318756 19.85686111 -17.67449188 81.86252594 19.93377304
		 -17.50436211 81.95307159 19.43088531 -15.1331377 82.15731049 14.75296211 -13.88754177 82.19025421 13.99846458
		 5.45557404 82.35590363 10.2044239 4.7151022 82.40102386 9.17099857 6.58355904 82.44545746 8.15326309
		 -18.95035172 81.35318756 19.37251282 -16.75468445 81.35318756 13.88272381 6.13962603 81.35318756 9.22850418
		 -4.50600815 78.75595856 36.80390549 -36.55757141 78.75595856 36.80390549 -36.55757141 78.75595856 21.5544796
		 -9.85165119 78.75595856 21.5544796 -4.32910919 78.75595856 25.50275993 -4.61992121 78.75595856 25.76799965
		 -10.68565559 78.75595856 34.65571976 -10.73955727 78.75595856 34.86801147 -11.3674612 82.24280548 36.80390549
		 -36.55757141 82.24280548 36.80390549 -11.30019569 80.52297211 36.80390549 -36.55757141 82.24280548 21.5544796
		 -9.69629478 82.24280548 21.5544796 -7.57637215 81.54532623 21.5544796 -10.83023453 82.24280548 34.68802643
		 -7.64176798 82.24280548 30.016178131 -2.16223311 82.24280548 25.018508911 -6.38134623 82.24280548 22.0020999908
		 -32.27711105 82.5683136 37.38755798 -34.0074958801 82.5683136 -12.16415215 -17.036973953 82.5683136 36.85536194
		 -17.036973953 86.055160522 36.85536194 -32.27711105 86.055160522 37.38755798 -33.99364853 86.055160522 -11.76767159
		 -34.8697319 82.5683136 -36.85536194 -19.6295948 82.5683136 -37.38755798 -34.8697319 86.055160522 -36.85536194
		 -19.6295948 86.055160522 -37.38755798;
	setAttr -s 144 ".ed[0:143]"  0 1 0 1 2 0 2 3 0 3 4 0 4 5 0 5 6 0 6 7 0
		 7 0 0 8 9 0 9 1 0 0 10 0 10 8 0 9 11 0 11 2 0 11 12 0 12 3 0 8 13 0 13 14 0 14 15 0
		 15 12 0 15 4 0 14 5 0 13 6 0 10 7 0 16 17 0 17 18 0 18 19 0 19 20 0 20 21 0 21 16 0
		 22 23 0 23 17 0 16 22 0 23 24 0 24 18 0 24 25 0 25 19 0 22 26 0 26 27 0 27 25 0 26 21 0
		 20 27 0 31 29 0 29 28 0 28 30 0 30 31 0 29 35 0 35 33 0 33 28 0 33 32 0 32 30 0 32 34 0
		 34 31 0 34 35 0 36 37 0 37 38 0 38 39 0 39 40 0 40 41 0 41 42 0 42 43 0 43 44 0 44 45 0
		 45 36 0 46 47 0 47 37 0 36 48 0 48 46 0 47 49 0 49 38 0 49 50 0 50 51 0 51 52 0 52 39 0
		 53 47 0 46 54 0 54 55 0 55 53 0 53 56 0 56 57 0 57 58 0 58 59 0 59 60 0 60 61 0 61 50 0
		 48 62 0 62 54 0 62 55 0 45 62 0 62 56 0 44 62 0 62 63 0 63 57 0 43 63 0 63 58 0 42 64 0
		 64 63 0 64 59 0 41 64 0 64 60 0 40 52 0 51 64 0 64 61 0 65 66 0 66 67 0 67 68 0 68 69 0
		 69 70 0 70 71 0 71 72 0 72 65 0 73 74 0 74 66 0 65 75 0 75 73 0 74 76 0 76 67 0 76 77 0
		 77 78 0 78 68 0 73 79 0 79 80 0 80 81 0 81 82 0 82 77 0 72 75 0 71 79 0 70 80 0 69 81 0
		 78 82 0 85 83 0 83 84 0 84 89 0 89 90 0 90 85 0 86 87 0 87 83 0 85 86 0 87 88 0 88 91 0
		 91 89 0 90 92 0 92 86 0 92 91 0;
	setAttr -s 288 ".n";
	setAttr ".n[0:165]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0
		 -1 0 0 -1 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.83285999 0.050074998
		 0.55121398 0.83285999 0.050074998 0.55121398 0.83285999 0.050074998 0.55121398 0.83285999
		 0.050074998 0.55121398 0.45267501 0.44184601 0.77450502 0.46235499 0.44577301 0.76649499
		 0.46021 0.444906 0.768287 0.45267501 0.44184601 0.77450502 0.46482399 0.446767 0.76442099
		 0.46021 0.444906 0.768287 0.46235499 0.44577301 0.76649499 0.46482301 0.446767 0.76442099
		 0.87177902 -0.485302 -0.066950001 0.87171501 -0.48567 -0.065094002 0.87171501 -0.48567
		 -0.065094002 0.87171501 -0.48567 -0.065094002 0.871723 -0.48562899 -0.065300003 0.871723
		 -0.48562899 -0.065300003 0.810368 -0.36480701 -0.458496 0.87177902 -0.485302 -0.066950001
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0.0087270001 0 0.99996197 0.0087270001
		 0 0.99996197 0.0087270001 0 0.99996197 0.0087270001 0 0.99996197 -0.99996197 0 0.0087270001
		 -0.99996197 0 0.0087270001 -0.99996197 0 0.0087270001 -0.99996197 0 0.0087270001
		 -0.0087270001 0 -0.99996197 -0.0087270001 0 -0.99996197 -0.0087270001 0 -0.99996197
		 -0.0087270001 0 -0.99996197 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.63102001 0.63491797
		 0.44575 0.43609199 0.558568 0.70556802 0.49824101 0.58742702 0.63771898 0.63102001
		 0.63491797 0.44575 0.81036103 -0.364802 -0.458514 0.81036001 -0.364802 -0.458514
		 0.81036001 -0.364802 -0.458514 0.81036001 -0.364802 -0.458514 0.43609199 0.558568
		 0.70556802 0.33817199 0.50715297 0.79273897 0.33817199 0.50715297 0.79273897 0.49824101
		 0.58742702 0.63771898 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1
		 0 0 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0.85332298
		 -0.490778 0.176 0.85332298 -0.490778 0.176 0.85332298 -0.490778 0.176 0.85332298
		 -0.490778 0.176 0 -0.99904799 -0.043618999 0 -0.99904799 -0.043618999 0 -0.99904799
		 -0.043618999 0 -0.99904799 -0.043618999 0 -0.99904799 -0.043618999 0 -0.99904799
		 -0.043618999 0 -0.99904799 -0.043618999 0 -0.99904799 -0.043618999 0 -0.99904799
		 -0.043618999 0 -0.99904799 -0.043618999 -0.026177 -0.043604001 0.99870598 -0.026177
		 -0.043604001 0.99870598 -0.026177 -0.043604001 0.99870598 -0.026177 -0.043604001
		 0.99870598 -0.026177 -0.043604001 0.99870598 -0.99965698 0.001142 -0.026152 -0.99965698
		 0.001142 -0.026152 -0.99965698 0.001142 -0.026152 -0.99965698 0.001142 -0.026152
		 0.026177 0.043605 -0.99870598 0.026177 0.043605 -0.99870598 0.026177 0.043605 -0.99870598
		 0.026177 0.043605 -0.99870598 0.026177 0.043605 -0.99870598 0.026177 0.043605 -0.99870598
		 -0.026177 -0.043604001 0.99870598 -0.026177 -0.043604001 0.99870598 -0.026177 -0.043604001
		 0.99870598 -0.026177 -0.043604001 0.99870598 -0.026177 -0.043604001 0.99870598 0
		 0.99904799 0.043618999 0 0.99904799 0.043618999 0 0.99904799 0.043618999 0 0.99904799
		 0.043618999 0 0.99904799 0.043618999 0 0.99904799 0.043618999 0 0.99904799 0.043618999
		 0 0.99904799 0.043618999 0 0.99904799 0.043618999 0 0.99904799 0.043618999 0.40571699
		 0.612351 0.67854297 0.40571699 0.612351 0.67854297 0.40571699 0.612351 0.67854297
		 0.40571699 0.612351 0.67854297 0.36201701 -0.931894 0.022741999 0.209885 -0.91254801
		 0.35100499 0.35975301 -0.91806 0.166566 0.64137501 -0.588449 -0.49230599 0.64137501
		 -0.588449 -0.49230599 0.64137501 -0.588449 -0.49230599 0.64137501 -0.588449 -0.49230599
		 0.35975301 -0.91806 0.166566 0.37432399 -0.91620702 0.14298999 0.38418901 -0.92254698
		 -0.036139 0.36201701 -0.931894 0.022741999 0.56508201 -0.55824703 0.60748899 0.84300601
		 -0.342547 0.41473201 0.78231102 -0.40555599 0.47277299;
	setAttr ".n[166:287]" -type "float3"  0.35634801 -0.91631597 0.182708 0.37432399
		 -0.91620702 0.14298999 0.35975301 -0.91806 0.166566 0.30351001 -0.85664201 0.41718799
		 0.84300601 -0.342547 0.41473201 0.89125502 -0.280357 0.35646099 0.89125502 -0.280357
		 0.35646099 0.78231102 -0.40555599 0.47277299 0.155462 -0.63690102 0.75510901 0.35634801
		 -0.91631597 0.182708 0.30351001 -0.85664201 0.41718799 0.19867501 -0.073716 0.97728902
		 0.19654 -0.063336998 0.97844797 0.134197 0.204735 0.96957499 0.19867501 -0.073716
		 0.97728902 0.15421 -0.63309002 0.75856203 0.155462 -0.63690102 0.75510901 0.30351001
		 -0.85664201 0.41718799 0.15421 -0.63309002 0.75856203 0.19654 -0.063336998 0.97844797
		 0.118577 0.263639 0.95730603 0.134197 0.204735 0.96957499 0.56031799 0.74149102 -0.36910099
		 0.56031799 0.74149102 -0.36910099 0.56031799 0.74149102 -0.36910099 0.39136699 0.62752801
		 0.67308301 0.37459001 0.67142302 0.63943303 0.37459001 0.67142302 0.63943303 0.37459001
		 0.67142302 0.63943303 0.38071799 0.65779299 0.649894 0.42245099 0.54283702 0.72585398
		 0.384848 0.56332099 0.73113698 0.39136699 0.62752801 0.67308301 0.39136699 0.62752801
		 0.67308301 0.38071799 0.65779299 0.649894 0.424977 0.54140902 0.72544599 0.42245099
		 0.54283702 0.72585398 0.228839 -0.68069601 -0.69590598 0.228839 -0.68069601 -0.69590598
		 0.228839 -0.68069601 -0.69590598 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0
		 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0
		 0 -1 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.19554301 0.75186801
		 -0.62964898 0.19554301 0.75186801 -0.62964898 0.19554301 0.75186801 -0.62964898 0.96855003
		 0.037882 0.24591701 0.85668498 0.030750999 0.51492202 0.858307 0.030843001 0.51220798
		 0.96855003 0.037882 0.24591701 0.96855003 0.037882 0.24591701 0.85668498 0.030750999
		 0.51492202 0.71374899 -0.199439 0.67140597 0.81217402 -0.0068870001 0.58337402 0.858307
		 0.030843001 0.51220798 0.71374899 -0.199439 0.67140597 0.64252502 -0.30145499 0.704476
		 0.64252502 -0.30145499 0.704476 0.81217402 -0.0068870001 0.58337402 0.52545899 -0.42861399
		 -0.73497099 0.52545899 -0.42861399 -0.73497099 0.52545899 -0.42861399 -0.73497099
		 0.52545899 -0.42861399 -0.73497099 0.52545899 -0.42861399 -0.73497099 0 0 -1 0 0
		 -1 0.123956 0.37675101 -0.917983 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0.034899 0 0.99939102
		 0.034899 0 0.99939102 0.034899 0 0.99939102 0.034899 0 0.99939102 -0.99939102 0 0.034899998
		 -0.99939102 0 0.034899998 -0.99939102 0 0.034899998 -0.99939102 0 0.034899998 -0.99939102
		 0 0.034899998 -0.99939102 0 0.034899998 0.99939102 0 -0.034899998 0.99939102 0 -0.034899998
		 0.99939102 0 -0.034899998 0.99939102 0 -0.034899998 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0
		 -0.034899 0 -0.99939102 -0.034899 0 -0.99939102 -0.034899 0 -0.99939102 -0.034899
		 0 -0.99939102;
	setAttr -s 63 -ch 288 ".fc[0:62]" -type "polyFaces" 
		f 8 0 1 2 3 4 5 6 7
		mu 0 8 0 1 2 3 4 5 6 7
		f 5 8 9 -1 10 11
		mu 0 5 8 9 10 11 12
		f 4 12 13 -2 -10
		mu 0 4 13 14 15 16
		f 4 -3 -14 14 15
		mu 0 4 17 18 19 20
		f 7 -15 -13 -9 16 17 18 19
		mu 0 7 21 22 23 24 25 26 27
		f 4 -4 -16 -20 20
		mu 0 4 28 29 30 31
		f 4 -19 21 -5 -21
		mu 0 4 31 32 33 28
		f 4 -6 -22 -18 22
		mu 0 4 34 33 32 35
		f 5 -7 -23 -17 -12 23
		mu 0 5 36 34 35 37 38
		f 3 -11 -8 -24
		mu 0 3 38 39 36
		f 6 24 25 26 27 28 29
		mu 0 6 40 41 42 43 44 45
		f 4 30 31 -25 32
		mu 0 4 46 47 48 49
		f 4 33 34 -26 -32
		mu 0 4 50 51 52 53
		f 4 -27 -35 35 36
		mu 0 4 54 55 56 57
		f 6 -36 -34 -31 37 38 39
		mu 0 6 58 59 60 61 62 63
		f 4 -39 40 -29 41
		mu 0 4 64 65 66 67
		f 4 -28 -37 -40 -42
		mu 0 4 67 68 69 64
		f 4 -38 -33 -30 -41
		mu 0 4 65 70 71 66
		f 4 42 43 44 45
		mu 0 4 72 73 74 75
		f 4 46 47 48 -44
		mu 0 4 76 77 78 79
		f 4 49 50 -45 -49
		mu 0 4 80 81 82 83
		f 4 51 52 -46 -51
		mu 0 4 84 85 86 87
		f 4 53 -47 -43 -53
		mu 0 4 88 89 90 91
		f 4 -48 -54 -52 -50
		mu 0 4 92 93 94 95
		f 10 54 55 56 57 58 59 60 61 62 63
		mu 0 10 96 97 98 99 100 101 102 103 104 105
		f 5 64 65 -55 66 67
		mu 0 5 106 107 108 109 110
		f 4 68 69 -56 -66
		mu 0 4 111 112 113 114
		f 6 70 71 72 73 -57 -70
		mu 0 6 115 116 117 118 119 120
		f 5 74 -65 75 76 77
		mu 0 5 121 107 106 122 123
		f 10 -71 -69 -75 78 79 80 81 82 83 84
		mu 0 10 124 125 126 127 128 129 130 131 132 133
		f 4 -76 -68 85 86
		mu 0 4 134 135 136 137
		f 3 -77 -87 87
		mu 0 3 138 134 137
		f 4 -67 -64 88 -86
		mu 0 4 136 139 140 137
		f 4 89 -79 -78 -88
		mu 0 4 137 141 142 138
		f 3 -63 90 -89
		mu 0 3 140 143 137
		f 4 -80 -90 91 92
		mu 0 4 144 141 137 145
		f 4 -62 93 -92 -91
		mu 0 4 143 146 145 137
		f 3 -81 -93 94
		mu 0 3 147 144 145
		f 4 -61 95 96 -94
		mu 0 4 146 148 149 145
		f 4 -82 -95 -97 97
		mu 0 4 150 147 145 149
		f 3 -60 98 -96
		mu 0 3 148 151 149
		f 3 -83 -98 99
		mu 0 3 152 150 149
		f 5 -99 -59 100 -73 101
		mu 0 5 149 151 153 154 155
		f 3 -84 -100 102
		mu 0 3 156 152 149
		f 4 -102 -72 -85 -103
		mu 0 4 149 155 157 156
		f 3 -58 -74 -101
		mu 0 3 153 158 154
		f 8 103 104 105 106 107 108 109 110
		mu 0 8 159 160 161 162 163 164 165 166
		f 5 111 112 -104 113 114
		mu 0 5 167 168 169 170 171
		f 4 115 116 -105 -113
		mu 0 4 172 173 174 175
		f 5 117 118 119 -106 -117
		mu 0 5 176 177 178 179 180
		f 8 -118 -116 -112 120 121 122 123 124
		mu 0 8 181 182 183 184 185 186 187 188
		f 3 -114 -111 125
		mu 0 3 189 190 191
		f 5 -110 126 -121 -115 -126
		mu 0 5 191 192 193 194 189
		f 4 -109 127 -122 -127
		mu 0 4 192 195 196 193
		f 4 -108 128 -123 -128
		mu 0 4 195 197 198 196
		f 5 -107 -120 129 -124 -129
		mu 0 5 197 199 200 201 198
		f 3 -119 -125 -130
		mu 0 3 200 202 201
		f 5 130 131 132 133 134
		mu 0 5 203 204 205 206 207
		f 4 135 136 -131 137
		mu 0 4 208 209 210 211
		f 6 -132 -137 138 139 140 -133
		mu 0 6 212 213 214 215 216 217
		f 4 -138 -135 141 142
		mu 0 4 218 219 220 221
		f 5 -139 -136 -143 143 -140
		mu 0 5 222 223 224 225 226
		f 4 -144 -142 -134 -141
		mu 0 4 227 228 229 230;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh12" -p "breakingcrate_geo";
	rename -uid "8952F6DD-4C3B-167F-DEC8-11A70C97920A";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" -36.44320011138916 43.402213335037231 -14.213162899017334 ;
	setAttr ".sp" -type "double3" -36.44320011138916 43.402213335037231 -14.213162899017334 ;
createNode mesh -n "breakingcrate_mesh12Shape" -p "breakingcrate_mesh12";
	rename -uid "89BBE97B-4A1C-D4BB-D9E2-6A9A474C9919";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh12ShapeOrig" -p "breakingcrate_mesh12";
	rename -uid "8FFCE689-4AC2-C224-D400-F7AB8F7D7B7D";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 234 ".uvst[0].uvsp[0:233]" -type "float2" 0.90731603 0.28587499
		 0.90731603 0.326538 0.89715397 0.326538 0.89715397 0.282626 0.90418798 0.28477499
		 0.90626401 0.284951 0.47534299 0.151853 0.47534299 0.0099999998 0.53014201 0.0099999998
		 0.53014201 0.111408 0.51942497 0.124103 0.49616301 0.14714301 0.976367 0.110031 0.966205
		 0.110031 0.966205 0.088058002 0.976367 0.088058002 0.80258399 0.36256501 0.80258399
		 0.30501801 0.814969 0.30696601 0.82843697 0.316237 0.83420002 0.31865299 0.83420002
		 0.36256501 0.89415199 0.71726102 0.89415199 0.63445997 0.901214 0.63445997 0.901214
		 0.71630299 0.63792431 -0.38614899 0.6220414 -0.38360661 0.62140793 -0.36963266 0.61668587
		 -0.33268625 0.63749695 -0.33268625 0.64220291 -0.36950272 0.64220291 -0.38635796
		 0.6451171 -0.38745099 0.61822641 -0.3064959 0.63899136 -0.30728352 0.78923601 0.127997
		 0.76955998 0.127997 0.76955998 0.119581 0.78923601 0.119581 0.97912502 0.821729 0.97912502
		 0.831945 0.97070801 0.831945 0.97070801 0.82210797 0.97301501 0.822326 0.59242898
		 0.056968998 0.59242898 0.0099999998 0.64149898 0.0099999998 0.64149898 0.035477001
		 0.63027298 0.031714 0.61380899 0.030726001 0.97462201 0.061724 0.97462201 0.084393002
		 0.966205 0.084393002 0.966205 0.065559998 0.96935397 0.062734999 0.96996099 0.061889
		 0.97053301 0.061992999 0.844405 0.53239399 0.844405 0.54223102 0.81609398 0.54223102
		 0.81609398 0.51956099 0.81668103 0.51966101 0.83693302 0.53409702 0.83742303 0.53430998
		 0.83841699 0.53408301 0.64220291 -0.42976627 0.63743001 -0.42949781 0.64058036 -0.42011544
		 0.64220291 -0.41849288 0.65692466 -0.41849288 0.65379852 -0.42903069 0.64105678 -0.41849288
		 0.65989661 -0.40079919 0.64100248 -0.41729245 0.64220291 -0.36075154 0.64520144 -0.36075154
		 0.65395904 -0.36423045 0.63377553 -0.36075154 0.6432457 -0.35970929 0.63384891 -0.35950664
		 0.64220291 -0.3598375 0.89830899 0.51381201 0.89831001 0.56521302 0.888147 0.56521302
		 0.888147 0.51284498 0.53388602 0.114908 0.53388602 0.0099999998 0.58868498 0.0099999998
		 0.58868498 0.13819 0.53483999 0.115247 0.97336501 0.98517603 0.96320301 0.98517603
		 0.96320301 0.96320301 0.97336501 0.96320301 0.799582 0.90296298 0.799582 0.85921198
		 0.81346899 0.85584402 0.83119798 0.85059398 0.83119798 0.90296298 0.89715397 0.18735
		 0.89715397 0.14359801 0.90731603 0.14359801 0.90731603 0.185665 0.907175 0.185651
		 0.90382397 0.18596999 0.64528716 -0.56644726 0.64705086 -0.6181376 0.62694919 -0.62443721
		 0.62594235 -0.59493726 0.63834876 -0.56769574 0.64497709 -0.56561869 0.64522171 -0.56550938
		 0.62422109 -0.57123905 0.90731603 0.049291998 0.90731603 0.107376 0.89715397 0.107376
		 0.89715397 0.048324998 0.51287103 0.39419901 0.51287103 0.27269399 0.56766999 0.27269399
		 0.56766999 0.41754901 0.976713 0.46483499 0.986875 0.46483499 0.986875 0.48680899
		 0.976713 0.48680899 0.80258399 0.23346899 0.80258399 0.18277 0.82142001 0.178203
		 0.83420002 0.174418 0.83420002 0.23346899 0.89415199 0.86379099 0.89415199 0.81309199
		 0.90431398 0.81309199 0.90431398 0.86181402 0.90319997 0.86192 0.63348508 -0.57109272
		 0.63573438 -0.57056826 0.6336118 -0.62316197 0.61309731 -0.62794906 0.61395532 -0.60668957
		 0.61401767 -0.57446021 0.53629798 0.82510102 0.53629798 0.84477699 0.52788198 0.84477699
		 0.52788198 0.82510102 0.98062599 0.62642801 0.98062599 0.64280498 0.97220898 0.64280498
		 0.97220898 0.62645501 0.97912699 0.625911 0.64496797 0.085139997 0.64496797 0.0099999998
		 0.69403702 0.0099999998 0.69403702 0.050843 0.69121802 0.052367002 0.66124201 0.051739998
		 0.976713 0.17253201 0.976713 0.14359801 0.985129 0.14359801 0.985129 0.173728 0.86692101
		 0.19413701 0.86692101 0.21048699 0.83861101 0.21048699 0.83861101 0.18155301 0.84763002
		 0.194417 0.64382863 -0.66859692 0.6439746 -0.67244303 0.64053333 -0.67187029 0.62729424
		 -0.67241728 0.63236493 -0.63499969 0.6483748 -0.63505322 0.62299359 -0.60335881 0.63861859
		 -0.60211241 0.89415199 0.37405199 0.89415199 0.34324601 0.90431398 0.34324601 0.90431398
		 0.374228 0.508367 0.63271201 0.508367 0.547396 0.56316602 0.547396 0.56316602 0.62422299
		 0.55861598 0.625848 0.54950303 0.63369501 0.50942999 0.63218999 0.96736002 0.57237202
		 0.95719802 0.57237202 0.95719802 0.55039799 0.96736002 0.55039799 0.799582 0.47214499
		 0.799582 0.43115401 0.803635 0.432538 0.81481802 0.432246 0.82866699 0.440534 0.83119798
		 0.44116199 0.83119798 0.47214499 0.88364398 0.280146 0.88364398 0.23666701 0.89322501
		 0.23666701 0.89322501 0.272953 0.65445763 -0.70222098 0.65434504 -0.70805579 0.63401663
		 -0.70784616 0.63412577 -0.70222098 0.63038355 -0.66570425 0.65303725 -0.68835789
		 0.65970463 -0.64447969 0.633609 -0.64447969 0.63344502 -0.63502568 0.65967977 -0.64304996
		 0.74233001 0.67633599 0.714019 0.67633599 0.714019 0.67048699 0.74233001 0.67048699
		 0.50489801 0.812635 0.45582899 0.812635 0.45582899 0.547396 0.50489801 0.547396 0.91307598
		 0.74081498 0.90465897 0.74081498 0.90465897 0.63445997 0.91307598 0.63445997 0.76484603
		 0.48863 0.73653603 0.48863 0.73653603 0.382274 0.76484603 0.382274 0.93108898 0.123861
		 0.92267299 0.123861 0.92267299 0.017506 0.93108898 0.017506 0.68115598 0.52788198
		 0.68115598 0.53629798 0.66148001 0.53629798 0.66148001 0.52788198;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 90 ".vt[0:89]"  -37.097164154 63.21327209 -3.45586395 -37.097164154 63.21327209 -32.15869904
		 -32.11177444 63.21327209 -32.15869904 -32.11177444 63.21327209 -1.16240597 -35.56255341 63.21327209 -2.67918801
		 -36.58110428 63.21327209 -2.80371404 -37.097164154 78.72370148 7.99177122 -37.097164154 78.72370148 -32.15869904
		 -37.097164154 66.24651337 0.13736001 -37.097164154 72.83071136 6.65845299 -32.11177444 78.72370148 -32.15869904
		 -32.11177444 78.72370148 8.46164894 -32.11177444 72.647995 7.086988926 -32.11177444 66.040557861 0.54288298
		 -40.33473969 58.92106247 -23.48249435 -40.33473969 72.80764771 -23.72488594 -36.20565796 72.80764771 -23.72488594
		 -36.20565796 58.92106247 -23.48249435 -40.33473969 59.046913147 -16.27242279 -36.20565796 59.042240143 -16.54029846
		 -37.33750534 59.039554596 -16.69413185 -40.33473969 73.039665222 -10.43267345 -40.33473969 62.20501709 -17.39292908
		 -40.33473969 66.8595047 -17.7537899 -36.20565796 73.086914063 -7.72551298 -38.78985977 73.074462891 -8.4391737
		 -38.49212265 73.084892273 -7.84164619 -38.21151352 73.083602905 -7.9153161 -36.20565796 72.79803467 -7.790874
		 -36.20565796 62.68636322 -17.80562973 -36.20565796 62.44345474 -17.95214081 -36.20565796 61.95864868 -17.78298378
		 -36.45649338 62.48085022 -18.039840698 -38.22439575 72.87202454 -7.96440077 -37.097164154 44.73800659 4.12476301
		 -37.097164154 44.73800659 -32.15869904 -32.11177444 44.73800659 -32.15869904 -32.11177444 44.73800659 4.80738401
		 -37.097164154 60.24843597 -2.46499109 -37.097164154 60.24843597 -32.15869904 -37.097164154 59.97834396 -2.36916208
		 -32.11177444 60.24843597 -32.15869904 -32.11177444 60.24843597 -1.27577996 -32.11177444 53.43579102 1.10124898
		 -37.028018951 60.24843597 -2.47478104 -35.38417053 60.24843597 -2.24969792 -35.9241333 28.90206146 8.8416872
		 -35.9241333 28.90206146 -32.15869904 -30.93874168 28.90206146 -32.15869904 -30.93874168 28.90206146 9.5243082
		 -35.9241333 44.41249466 2.23267388 -35.9241333 44.41249466 -32.15869904 -30.93874168 44.41249466 -32.15869904
		 -30.93874168 44.41249466 3.62856293 -30.93874168 35.1717186 6.85279989 -35.37747192 44.41249466 2.30752492
		 -40.33473969 17.63767624 -23.83526039 -40.33473969 31.51791954 -23.35055161 -36.20565796 31.51791954 -23.35055161
		 -36.20565796 17.63767624 -23.83526039 -40.33473969 17.23423004 -12.28207493 -36.20565796 17.23490143 -12.30128479
		 -39.59951782 17.22149658 -11.91743088 -40.33473969 30.77568436 -2.095732927 -40.33473969 18.016775131 -11.82309914
		 -40.33473969 26.50208282 -11.70428181 -36.20565796 30.80514145 -2.93923402 -36.20565796 26.70012283 -12.16874599
		 -37.097164154 7.20095301 -10.41352463 -37.097164154 7.20095301 -32.15869904 -32.11177444 7.20095301 -32.15869904
		 -32.11177444 7.20095301 -10.28869247 -37.097164154 22.71138573 -8.01058197 -37.097164154 22.71138573 -32.15869904
		 -37.097164154 8.48883724 -9.95344257 -37.097164154 11.068120003 -7.73246717 -37.097164154 22.41065598 -8.15837479
		 -32.11177444 22.71138573 -32.15869904 -32.11177444 22.71138573 -3.22382998 -32.11177444 20.72325134 -4.20089293
		 -32.11177444 15.23669338 -3.99487495 -32.11177444 8.44264603 -9.84511089 -41.94765854 5.74968576 -24.06403923
		 -41.94765854 5.99207687 -37.950634 -37.81857681 5.99207687 -37.950634 -37.81857681 5.74968576 -24.06403923
		 -41.94765854 80.81235504 -22.7538147 -41.94765854 81.054740906 -36.64040756 -37.81857681 81.054740906 -36.64040756
		 -37.81857681 80.81235504 -22.7538147;
	setAttr -s 138 ".ed[0:137]"  0 1 0 1 2 0 2 3 0 3 4 0 4 5 0 5 0 0 6 7 0
		 7 1 0 0 8 0 8 9 0 9 6 0 7 10 0 10 2 0 10 11 0 11 12 0 12 13 0 13 3 0 6 11 0 13 4 0
		 12 9 0 8 5 0 14 15 0 15 16 0 16 17 0 17 14 0 18 14 0 17 19 0 19 20 0 20 18 0 21 15 0
		 18 22 0 22 23 0 23 21 0 24 16 0 21 25 0 25 26 0 26 27 0 27 24 0 24 28 0 28 29 0 29 30 0
		 30 31 0 31 19 0 31 32 0 32 20 0 32 22 0 30 32 0 32 23 0 29 32 0 32 33 0 33 25 0 28 33 0
		 33 26 0 27 33 0 34 35 0 35 36 0 36 37 0 37 34 0 38 39 0 39 35 0 34 40 0 40 38 0 39 41 0
		 41 36 0 41 42 0 42 43 0 43 37 0 38 44 0 44 45 0 45 42 0 43 45 0 44 40 0 46 47 0 47 48 0
		 48 49 0 49 46 0 50 51 0 51 47 0 46 50 0 51 52 0 52 48 0 52 53 0 53 54 0 54 49 0 50 55 0
		 55 53 0 54 55 0 56 57 0 57 58 0 58 59 0 59 56 0 60 56 0 59 61 0 61 62 0 62 60 0 63 57 0
		 60 64 0 64 65 0 65 63 0 66 58 0 63 66 0 66 67 0 67 61 0 62 64 0 67 65 0 68 69 0 69 70 0
		 70 71 0 71 68 0 72 73 0 73 69 0 68 74 0 74 75 0 75 76 0 76 72 0 73 77 0 77 70 0 77 78 0
		 78 79 0 79 80 0 80 81 0 81 71 0 72 78 0 81 74 0 80 75 0 79 76 0 82 83 0 83 84 0 84 85 0
		 85 82 0 86 87 0 87 83 0 82 86 0 87 88 0 88 84 0 88 89 0 89 85 0 89 86 0;
	setAttr -s 276 ".n";
	setAttr ".n[0:165]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0
		 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.093842 -0.69635499 0.71153599
		 -0.35225901 -0.48337501 0.801413 -0.094635002 -0.69584 0.71193397 -0.094635002 -0.69584
		 0.71193397 -0.086539 -0.70105398 0.707838 -0.086539 -0.70105398 0.707838 -0.086539
		 -0.70105398 0.707838 -0.086539 -0.70105398 0.707838 -0.093842 -0.69635499 0.71153599
		 -0.63183302 -0.59228897 0.49998099 -0.63183302 -0.59228897 0.49998099 -0.63183302
		 -0.59228897 0.49998099 -0.091541 -0.219751 0.97125202 -0.091541 -0.21975 0.97125202
		 -0.091541 -0.21975 0.97125202 -0.091541 -0.219751 0.97125202 0 -0.017452 -0.99984801
		 0 -0.017452 -0.99984801 0 -0.017452 -0.99984801 0 -0.017452 -0.99984801 0 -0.99984801
		 0.017452 0 -0.99984801 0.017452 0 -0.99984801 0.017452 0 -0.99984801 0.017452 0 -0.99984801
		 0.017452 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0.99984801 -0.017452 0 0.99984801
		 -0.017452 0 0.99984801 -0.017452 0 0.99984801 -0.017452 0 0.99984801 -0.017452 0
		 0.99984801 -0.017452 0 0.99984801 -0.017452 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1
		 0 0 1 0 0 0.097758003 0.34064001 0.93509799 -0.124978 0.388924 0.91275299 -0.125579
		 0.388652 0.91278702 0.124595 0.25117201 0.95989001 0.144053 0.231205 0.96218097 0.13225
		 0.331444 0.93415999 0.097758003 0.34064001 0.93509799 0.124595 0.25117201 0.95989001
		 -0.125579 0.388652 0.91278702 -0.27052599 0.31716099 0.90896899 0.124595 0.25117201
		 0.95989001 0.158768 0.076316997 0.98436201 0.144053 0.231205 0.96218097 0.124595
		 0.25117201 0.95989001 -0.352263 -0.48337901 0.80140901 -0.086723998 -0.70093501 0.70793301
		 -0.087149002 -0.70066297 0.70815003 -0.63183302 -0.592287 0.49998301 -0.63168103
		 -0.59278101 0.49959099 -0.63179702 -0.59240502 0.49988899 -0.63183302 -0.592287 0.49998301
		 -0.63183302 -0.592287 0.49998301 -0.086723998 -0.70093501 0.70793301 -0.086538002
		 -0.70105398 0.707838 -0.086538002 -0.70105398 0.707838 -0.087149002 -0.70066297 0.70815003
		 -0.51901799 -0.81007802 0.27275199 -0.63179702 -0.59240502 0.49988899 -0.63168103
		 -0.59278101 0.49959099 -0.091541 -0.21975 0.97125202 -0.091541 -0.21975 0.97125202
		 -0.073260002 -0.22115 0.97248399 -0.079714 -0.22066399 0.97208703 -0.073260002 -0.22115
		 0.97248399 0.24592701 -0.23325101 0.94080502 -0.079714 -0.22066399 0.97208703 0 -1
		 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0
		 0 -1 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 -0.124975
		 0.38892499 0.91275299 -0.124978 0.38892499 0.91275299 -0.124978 0.38892499 0.91275299
		 -0.12874199 0.38721699 0.912956 -0.136829 0.38352099 0.91333997 -0.124952 0.38892099
		 0.91275799 -0.124952 0.38892099 0.91275799 0.13224401 0.33143899 0.93416297 -0.124975
		 0.38892499 0.91275299 -0.12874199 0.38721699 0.912956 -0.27052501 0.31715199 0.90897202
		 -0.136829 0.38352099 0.91333997 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1
		 0 0 1 0 0 1 0;
	setAttr ".n[166:275]" -type "float3"  -0.14823 0.37825099 0.91375798 -0.124978
		 0.38892499 0.91275299 -0.124978 0.38892499 0.91275299 -0.124978 0.38892499 0.91275299
		 -0.132815 0.38536 0.913158 -0.132815 0.38536 0.913158 -0.27052501 0.31715301 0.90897202
		 -0.14823 0.37825099 0.91375798 0 0.034899 -0.99939102 0 0.034899 -0.99939102 0 0.034899
		 -0.99939102 0 0.034899 -0.99939102 0 -0.99939102 -0.034899 0 -0.99939102 -0.034899
		 0 -0.99939102 -0.034899 0 -0.99939102 -0.034899 0 -0.99939102 -0.034899 -1 0 0 -1
		 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0.99939102 0.034899998 0 0.99939102 0.034899998
		 0 0.99939102 0.034899998 0 0.99939102 0.034899998 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 -0.40010399
		 -0.463658 0.79053003 -0.40010399 -0.463658 0.79053003 -0.40010399 -0.463658 0.79053003
		 0.112429 -0.013913 0.99356198 0.112429 -0.013913 0.99356198 0.112429 -0.013913 0.99356198
		 0.112429 -0.013913 0.99356198 0.112429 -0.013913 0.99356198 0.08918 -0.91005999 0.40476799
		 0.08918 -0.91005999 0.40476799 0.08918 -0.91005999 0.40476799 0.08918 -0.91005999
		 0.40476799 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1
		 0 0 1 0 0 1 0 0 1 0 -0.022924 -0.60172999 0.79837 -0.023574 -0.33632299 0.94145203
		 -0.023574 -0.33632299 0.94145203 -0.022921 -0.60204399 0.79813403 -0.022921 -0.60204399
		 0.79813403 -0.022506 -0.65234601 0.75758702 -0.022506 -0.65234601 0.75758702 -0.022924
		 -0.60172999 0.79837 -0.62732899 -0.028205 0.77824402 -0.61530501 0.029579001 0.78773397
		 -0.61530501 0.029579001 0.78773397 -0.62462401 -0.01423 0.78079599 -0.62462401 -0.01423
		 0.78079599 -0.65278703 -0.33412299 0.67987603 -0.65278703 -0.33412299 0.67987603
		 -0.62732899 -0.028205 0.77824402 0 -0.99984801 -0.017452 0 -0.99984801 -0.017452
		 0 -0.99984801 -0.017452 0 -0.99984801 -0.017452 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 0.017452
		 -0.99984801 0 0.017452 -0.99984801 0 0.017452 -0.99984801 0 0.017452 -0.99984801
		 1 0 0 1 0 0 1 0 0 1 0 0 0 -0.017452 0.99984801 0 -0.017452 0.99984801 0 -0.017452
		 0.99984801 0 -0.017452 0.99984801 0 0.99984801 0.017452 0 0.99984801 0.017452 0 0.99984801
		 0.017452 0 0.99984801 0.017452;
	setAttr -s 62 -ch 276 ".fc[0:61]" -type "polyFaces" 
		f 6 0 1 2 3 4 5
		mu 0 6 0 1 2 3 4 5
		f 6 6 7 -1 8 9 10
		mu 0 6 6 7 8 9 10 11
		f 4 11 12 -2 -8
		mu 0 4 12 13 14 15
		f 6 13 14 15 16 -3 -13
		mu 0 6 16 17 18 19 20 21
		f 4 -14 -12 -7 17
		mu 0 4 22 23 24 25
		f 3 -4 -17 18
		mu 0 3 26 27 28
		f 6 -16 19 -10 20 -5 -19
		mu 0 6 28 29 30 31 32 26
		f 3 -9 -6 -21
		mu 0 3 31 33 32
		f 4 -15 -18 -11 -20
		mu 0 4 29 34 35 30
		f 4 21 22 23 24
		mu 0 4 36 37 38 39
		f 5 25 -25 26 27 28
		mu 0 5 40 41 42 43 44
		f 6 29 -22 -26 30 31 32
		mu 0 6 45 46 47 48 49 50
		f 7 33 -23 -30 34 35 36 37
		mu 0 7 51 52 53 54 55 56 57
		f 8 -27 -24 -34 38 39 40 41 42
		mu 0 8 58 59 60 61 62 63 64 65
		f 4 -28 -43 43 44
		mu 0 4 66 67 68 69
		f 4 -31 -29 -45 45
		mu 0 4 70 71 66 69
		f 3 -42 46 -44
		mu 0 3 68 72 69
		f 3 -32 -46 47
		mu 0 3 73 70 69
		f 3 -41 48 -47
		mu 0 3 72 74 69
		f 5 49 50 -35 -33 -48
		mu 0 5 69 75 76 77 73
		f 4 -40 51 -50 -49
		mu 0 4 74 78 75 69
		f 3 -36 -51 52
		mu 0 3 79 76 75
		f 4 -39 -38 53 -52
		mu 0 4 78 80 81 75
		f 3 -37 -53 -54
		mu 0 3 81 79 75
		f 4 54 55 56 57
		mu 0 4 82 83 84 85
		f 5 58 59 -55 60 61
		mu 0 5 86 87 88 89 90
		f 4 62 63 -56 -60
		mu 0 4 91 92 93 94
		f 5 64 65 66 -57 -64
		mu 0 5 95 96 97 98 99
		f 6 -65 -63 -59 67 68 69
		mu 0 6 100 101 102 103 104 105
		f 6 -61 -58 -67 70 -69 71
		mu 0 6 106 107 108 109 110 111
		f 3 -68 -62 -72
		mu 0 3 111 112 106
		f 3 -66 -70 -71
		mu 0 3 109 113 110
		f 4 72 73 74 75
		mu 0 4 114 115 116 117
		f 4 76 77 -73 78
		mu 0 4 118 119 120 121
		f 4 79 80 -74 -78
		mu 0 4 122 123 124 125
		f 5 81 82 83 -75 -81
		mu 0 5 126 127 128 129 130
		f 5 -82 -80 -77 84 85
		mu 0 5 131 132 133 134 135
		f 5 -85 -79 -76 -84 86
		mu 0 5 136 137 138 139 140
		f 3 -83 -86 -87
		mu 0 3 140 141 136
		f 4 87 88 89 90
		mu 0 4 142 143 144 145
		f 5 91 -91 92 93 94
		mu 0 5 146 147 148 149 150
		f 6 95 -88 -92 96 97 98
		mu 0 6 151 152 153 154 155 156
		f 4 99 -89 -96 100
		mu 0 4 157 158 159 160
		f 5 -93 -90 -100 101 102
		mu 0 5 161 162 163 164 165
		f 3 -97 -95 103
		mu 0 3 166 167 168
		f 5 -94 -103 104 -98 -104
		mu 0 5 168 169 170 171 166
		f 4 -102 -101 -99 -105
		mu 0 4 170 172 173 171
		f 4 105 106 107 108
		mu 0 4 174 175 176 177
		f 7 109 110 -106 111 112 113 114
		mu 0 7 178 179 180 181 182 183 184
		f 4 115 116 -107 -111
		mu 0 4 185 186 187 188
		f 7 117 118 119 120 121 -108 -117
		mu 0 7 189 190 191 192 193 194 195
		f 4 -118 -116 -110 122
		mu 0 4 196 197 198 199
		f 4 -112 -109 -122 123
		mu 0 4 200 201 202 203
		f 4 -121 124 -113 -124
		mu 0 4 203 204 205 200
		f 4 -114 -125 -120 125
		mu 0 4 206 205 204 207
		f 4 -119 -123 -115 -126
		mu 0 4 207 208 209 206
		f 4 126 127 128 129
		mu 0 4 210 211 212 213
		f 4 130 131 -127 132
		mu 0 4 214 215 216 217
		f 4 133 134 -128 -132
		mu 0 4 218 219 220 221
		f 4 135 136 -129 -135
		mu 0 4 222 223 224 225
		f 4 137 -133 -130 -137
		mu 0 4 226 227 228 229
		f 4 -138 -136 -134 -131
		mu 0 4 230 231 232 233;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_mesh13" -p "breakingcrate_geo";
	rename -uid "3219E14E-4AEC-47D5-E405-A093B539CE47";
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
	setAttr ".rp" -type "double3" -36.44320011138916 43.402213335037231 9.9553966522216797 ;
	setAttr ".sp" -type "double3" -36.44320011138916 43.402213335037231 9.9553966522216797 ;
createNode mesh -n "breakingcrate_mesh13Shape" -p "breakingcrate_mesh13";
	rename -uid "4AAF8943-40A4-F3F1-8CBE-8C87722B10BD";
	setAttr -k off ".v";
	setAttr -s 8 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".bw" 3;
	setAttr ".vcs" 2;
createNode mesh -n "breakingcrate_mesh13ShapeOrig" -p "breakingcrate_mesh13";
	rename -uid "3A5CE02F-47AA-FEB4-B79B-EDBDE9D3C320";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr -s 234 ".uvst[0].uvsp[0:233]" -type "float2" 0.90731603 0.23666701
		 0.90731603 0.28587499 0.90626401 0.284951 0.90418798 0.28477499 0.89715397 0.282626
		 0.89715397 0.23666701 0.83560902 0.470494 0.83560902 0.46033201 0.85758197 0.46033201
		 0.85758197 0.470494 0.47534299 0.234128 0.47534299 0.151853 0.49616301 0.14714301
		 0.51942497 0.124103 0.53014201 0.111408 0.53014201 0.234128 0.80258399 0.30501801
		 0.80258399 0.27269399 0.83420002 0.27269399 0.83420002 0.31865299 0.82843697 0.316237
		 0.814969 0.30696601 0.901214 0.71630299 0.901214 0.763771 0.89415199 0.763771 0.89415199
		 0.71726102 0.65241432 -0.41459125 0.6530478 -0.42856467 0.66893065 -0.43110761 0.67320931
		 -0.43131605 0.67320931 -0.41446134 0.66850394 -0.37764487 0.64769226 -0.37764487
		 0.66999835 -0.35224214 0.6492328 -0.35145456 0.6761235 -0.43240967 0.64149898 0.17681099
		 0.59242898 0.17681099 0.59242898 0.056968998 0.61380899 0.030726001 0.63027298 0.031714
		 0.64149898 0.035477001 0.97070801 0.76505703 0.97912502 0.76505703 0.97912502 0.821729
		 0.97301501 0.822326 0.97070801 0.82210797 0.74119997 0.119581 0.74119997 0.127997
		 0.721524 0.127997 0.721524 0.119581 0.966205 0.017506 0.97462201 0.017506 0.97462201
		 0.061724 0.97053301 0.061992999 0.96996099 0.061889 0.96935397 0.062734999 0.966205
		 0.065559998 0.81609398 0.47534299 0.844405 0.47534299 0.844405 0.53239399 0.83841699
		 0.53408301 0.83742303 0.53430998 0.83693302 0.53409702 0.81668103 0.51966101 0.81609398
		 0.51956099 0.66083705 -0.41181138 0.66036069 -0.41343394 0.66198319 -0.41181138 0.66078275
		 -0.41061097 0.65721089 -0.42281631 0.66198319 -0.42308483 0.65355587 -0.35407004
		 0.66198319 -0.35407004 0.67357939 -0.42234862 0.67670494 -0.41181138 0.66198319 -0.353156
		 0.65362918 -0.35282457 0.67967689 -0.39411771 0.67373931 -0.35754839 0.66498232 -0.35407004
		 0.66302598 -0.35302725 0.76521802 0.127997 0.74554199 0.127997 0.74554199 0.119581
		 0.76521802 0.119581 0.351785 0.53793299 0.30271599 0.53793299 0.30271599 0.27269399
		 0.351785 0.27269399 0.76505703 0.80993497 0.76505703 0.80408502 0.91808599 0.80408502
		 0.91808599 0.80993497 0.79937202 0.37904999 0.771061 0.37904999 0.771061 0.27269399
		 0.79937202 0.27269399 0.91607797 0.91944802 0.90766197 0.91944802 0.90766197 0.81309199
		 0.91607797 0.81309199 0.71718299 0.119581 0.71718299 0.127997 0.69750702 0.127997
		 0.69750702 0.119581 0.888147 0.51284498 0.888147 0.47534299 0.89831001 0.47534299
		 0.89830899 0.51381201 0.799582 0.85921198 0.799582 0.81309199 0.83119798 0.81309199
		 0.83119798 0.85059398 0.81346899 0.85584402 0.89680803 0.46579301 0.88664597 0.46579301
		 0.88664597 0.44382 0.89680803 0.44382 0.53388602 0.234126 0.53388602 0.114908 0.53483999
		 0.115247 0.58868498 0.13819 0.58868498 0.234126 0.90731603 0.23346999 0.89715397
		 0.23346999 0.89715397 0.18735 0.90382397 0.18596999 0.907175 0.185651 0.90731603
		 0.185665 0.63137585 -0.34324524 0.61722338 -0.34668839 0.61877787 -0.37039873 0.61957687
		 -0.39990512 0.63972276 -0.39374653 0.63832289 -0.34204569 0.63801849 -0.34121448
		 0.638264 -0.3411074 0.89715397 0.048324998 0.89715397 0.017506 0.90731603 0.017506
		 0.90731603 0.049291998 0.80258399 0.18277 0.80258399 0.14359801 0.83420002 0.14359801
		 0.83420002 0.174418 0.82142001 0.178203 0.95384997 0.27665401 0.94368798 0.27665401
		 0.94368798 0.25468001 0.95384997 0.25468001 0.56766999 0.41754901 0.56766999 0.49682
		 0.51287103 0.49682 0.51287103 0.39419901 0.90431398 0.90296298 0.89415199 0.90296298
		 0.89415199 0.86379099 0.90319997 0.86192 0.90431398 0.86181402 0.63184202 -0.34512433
		 0.6125406 -0.34934044 0.6138888 -0.38154176 0.61396194 -0.40281841 0.6342479 -0.39713797
		 0.63406658 -0.34450117 0.69403702 0.17681099 0.64496797 0.17681099 0.64496797 0.085139997
		 0.66124201 0.051739998 0.69121802 0.052367002 0.69403702 0.050843 0.97220898 0.57591701
		 0.98062599 0.57591701 0.98062599 0.62642801 0.97912699 0.625911 0.97220898 0.62645501
		 0.80124497 0.52788198 0.80124497 0.53629798 0.781569 0.53629798 0.781569 0.52788198
		 0.985129 0.173728 0.985129 0.21048599 0.976713 0.21048599 0.976713 0.17253201 0.83861101
		 0.14359801 0.86692101 0.14359801 0.86692101 0.19413701 0.84763002 0.194417 0.83861101
		 0.18155301 0.63420594 -0.59797651 0.62877542 -0.63534296 0.64201915 -0.63492382 0.64534628
		 -0.63168174 0.65021402 -0.59818387 0.64077544 -0.56515086 0.62513918 -0.56624651
		 0.6454553 -0.63552964 0.90431398 0.374228 0.90431398 0.43311599 0.89415199 0.43311599
		 0.89415199 0.37405199 0.799582 0.43115401 0.799582 0.382274 0.83119798 0.382274 0.83119798
		 0.44116199 0.82866699 0.440534 0.81481802 0.432246 0.803635 0.432538 0.85662401 0.77822101
		 0.85662401 0.76805902 0.87859702 0.76805902 0.87859702 0.77822101 0.508367 0.77152401
		 0.508367 0.63271201 0.50942999 0.63218999 0.54950303 0.63369501 0.55861598 0.625848
		 0.56316602 0.62422299 0.56316602 0.77152401 0.89322501 0.272953 0.89322501 0.33199099
		 0.88364398 0.33199099 0.88364398 0.280146 0.61461467 -0.71350133 0.61450613 -0.71912646
		 0.63483393 -0.7193355 0.63494712 -0.71350133 0.61087245 -0.67698455 0.63352609 -0.69963819
		 0.64019412 -0.65575993 0.61409783 -0.65575993 0.64016926 -0.65432972 0.61393392 -0.64630598;
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 90 ".vt[0:89]"  -37.097164154 63.21327209 31.27892303 -37.097164154 63.21327209 -3.45586395
		 -36.58110428 63.21327209 -2.80371404 -35.56255341 63.21327209 -2.67918801 -32.11177444 63.21327209 -1.16240597
		 -32.11177444 63.21327209 31.27892303 -32.11177444 78.72370148 31.27892303 -37.097164154 78.72370148 31.27892303
		 -37.097164154 78.72370148 7.99177122 -37.097164154 72.83071136 6.65845299 -37.097164154 66.24651337 0.13736001
		 -32.11177444 78.72370148 8.46164894 -32.11177444 66.040557861 0.54288298 -32.11177444 72.647995 7.086988926
		 -40.33473969 59.7450676 23.72488594 -40.33473969 73.63165283 23.48249435 -40.33473969 73.039665222 -10.43267345
		 -40.33473969 66.8595047 -17.7537899 -40.33473969 62.20501709 -17.39292908 -40.33473969 59.046913147 -16.27242279
		 -36.20565796 59.7450676 23.72488594 -37.33750534 59.039554596 -16.69413185 -36.20565796 59.042240143 -16.54029846
		 -36.20565796 73.63165283 23.48249435 -36.20565796 73.086914063 -7.72551298 -38.21151352 73.083602905 -7.9153161
		 -38.49212265 73.084892273 -7.84164619 -38.78985977 73.074462891 -8.4391737 -36.20565796 61.95864868 -17.78298378
		 -36.20565796 62.44345474 -17.95214081 -36.20565796 62.68636322 -17.80562973 -36.20565796 72.79803467 -7.790874
		 -36.45649338 62.48085022 -18.039840698 -38.22439575 72.87202454 -7.96440077 -41.94765854 5.99207687 37.950634
		 -41.94765854 5.74968576 24.064043045 -37.81857681 5.74968576 24.064043045 -37.81857681 5.99207687 37.950634
		 -41.94765854 81.054740906 36.64040756 -41.94765854 80.81235504 22.75381851 -37.81857681 80.81235504 22.75381851
		 -37.81857681 81.054740906 36.64040756 -32.11177444 44.73800659 4.80738401 -32.11177444 44.73800659 31.27892303
		 -37.097164154 44.73800659 31.27892303 -37.097164154 44.73800659 4.12476301 -32.11177444 60.24843597 -1.27577996
		 -32.11177444 60.24843597 31.27892303 -32.11177444 53.43579102 1.10124898 -37.097164154 60.24843597 31.27892303
		 -37.097164154 60.24843597 -2.46499109 -37.097164154 59.97834396 -2.36916208 -35.38417053 60.24843597 -2.24969792
		 -37.028018951 60.24843597 -2.47478104 -30.93874168 28.90206146 9.5243082 -30.93874168 28.90206146 31.27892303
		 -35.9241333 28.90206146 31.27892303 -35.9241333 28.90206146 8.8416872 -30.93874168 44.41249466 3.62856293
		 -30.93874168 44.41249466 31.27892303 -30.93874168 35.1717186 6.85279989 -35.9241333 44.41249466 31.27892303
		 -35.9241333 44.41249466 2.23267388 -35.37747192 44.41249466 2.30752492 -40.33473969 15.98991203 23.35055161
		 -40.33473969 29.87015533 23.83526039 -40.33473969 30.77568436 -2.095732927 -40.33473969 26.50208282 -11.70428181
		 -40.33473969 18.016775131 -11.82309914 -40.33473969 17.23423004 -12.28207493 -36.20565796 15.98991203 23.35055161
		 -39.59951782 17.22149658 -11.91743088 -36.20565796 17.23490143 -12.30128479 -36.20565796 29.87015533 23.83526039
		 -36.20565796 30.80514145 -2.93923402 -36.20565796 26.70012283 -12.16874599 -32.11177444 7.20095301 -10.28869247
		 -32.11177444 7.20095301 31.27892303 -37.097164154 7.20095301 31.27892303 -37.097164154 7.20095301 -10.41352463
		 -32.11177444 22.71138573 -3.22382998 -32.11177444 22.71138573 31.27892303 -32.11177444 8.44264603 -9.84511089
		 -32.11177444 15.23669338 -3.99487495 -32.11177444 20.72325134 -4.20089293 -37.097164154 22.71138573 31.27892303
		 -37.097164154 22.71138573 -8.01058197 -37.097164154 22.41065598 -8.15837479 -37.097164154 11.068120003 -7.73246717
		 -37.097164154 8.48883724 -9.95344257;
	setAttr -s 138 ".ed[0:137]"  0 1 0 1 2 0 2 3 0 3 4 0 4 5 0 5 0 0 6 7 0
		 7 0 0 5 6 0 7 8 0 8 9 0 9 10 0 10 1 0 11 6 0 4 12 0 12 13 0 13 11 0 11 8 0 3 12 0
		 2 10 0 9 13 0 14 15 0 15 16 0 16 17 0 17 18 0 18 19 0 19 14 0 20 14 0 19 21 0 21 22 0
		 22 20 0 20 23 0 23 15 0 23 24 0 24 25 0 25 26 0 26 27 0 27 16 0 22 28 0 28 29 0 29 30 0
		 30 31 0 31 24 0 28 32 0 32 29 0 32 30 0 21 32 0 32 33 0 33 31 0 18 32 0 33 25 0 32 17 0
		 27 33 0 33 26 0 34 35 0 35 36 0 36 37 0 37 34 0 38 39 0 39 35 0 34 38 0 39 40 0 40 36 0
		 40 41 0 41 37 0 41 38 0 42 43 0 43 44 0 44 45 0 45 42 0 46 47 0 47 43 0 42 48 0 48 46 0
		 47 49 0 49 44 0 49 50 0 50 51 0 51 45 0 46 52 0 52 53 0 53 50 0 48 52 0 51 53 0 54 55 0
		 55 56 0 56 57 0 57 54 0 58 59 0 59 55 0 54 60 0 60 58 0 59 61 0 61 56 0 61 62 0 62 57 0
		 58 63 0 63 62 0 60 63 0 64 65 0 65 66 0 66 67 0 67 68 0 68 69 0 69 64 0 70 64 0 69 71 0
		 71 72 0 72 70 0 70 73 0 73 65 0 73 74 0 74 66 0 72 75 0 75 74 0 71 68 0 67 75 0 76 77 0
		 77 78 0 78 79 0 79 76 0 80 81 0 81 77 0 76 82 0 82 83 0 83 84 0 84 80 0 81 85 0 85 78 0
		 85 86 0 86 87 0 87 88 0 88 89 0 89 79 0 80 86 0 89 82 0 88 83 0 87 84 0;
	setAttr -s 276 ".n";
	setAttr ".n[0:165]" -type "float3"  0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0
		 0 1 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0.094635002 0.69584 -0.71193397
		 0.35225901 0.48337501 -0.801413 0.093842 0.69635499 -0.71153599 0.093842 0.69635499
		 -0.71153599 0.086539 0.70105398 -0.707838 0.086539 0.70105398 -0.707838 0.086539
		 0.70105398 -0.707838 0.086539 0.70105398 -0.707838 0.094635002 0.69584 -0.71193397
		 0.091541 0.219751 -0.97125202 0.091541 0.219751 -0.97125202 0.091541 0.219751 -0.97125202
		 0.091541 0.219751 -0.97125202 0.63183302 0.59228897 -0.49998099 0.63183302 0.59228897
		 -0.49998099 0.63183302 0.59228897 -0.49998099 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 -1 0 0 0 -0.99984801 0.017452 0 -0.99984801 0.017452 0 -0.99984801 0.017452 0 -0.99984801
		 0.017452 0 -0.99984801 0.017452 0 0.017452 0.99984801 0 0.017452 0.99984801 0 0.017452
		 0.99984801 0 0.017452 0.99984801 0 0.99984801 -0.017452 0 0.99984801 -0.017452 0
		 0.99984801 -0.017452 0 0.99984801 -0.017452 0 0.99984801 -0.017452 0 0.99984801 -0.017452
		 0 0.99984801 -0.017452 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0.27052999
		 -0.31715399 -0.90897 0.125579 -0.38865301 -0.91278601 -0.124595 -0.25117201 -0.95989001
		 0.086724997 0.70093602 -0.707932 0.35226101 0.48337901 -0.80140901 0.08715 0.70066398
		 -0.70814902 0.125579 -0.38865301 -0.91278601 0.124978 -0.38892499 -0.91275299 -0.097758003
		 -0.34064001 -0.93509799 -0.124595 -0.25117201 -0.95989001 0.086539 0.70105499 -0.70783699
		 0.086724997 0.70093602 -0.707932 0.08715 0.70066398 -0.70814902 0.086539 0.70105398
		 -0.70783699 -0.124595 -0.25117201 -0.95989001 -0.097758003 -0.34064001 -0.93509799
		 -0.13225 -0.33144301 -0.93415999 -0.144053 -0.231205 -0.96218097 0.073261999 0.22115301
		 -0.97248399 0.091541998 0.219753 -0.97125101 0.091541998 0.219753 -0.97125101 0.079714999
		 0.220667 -0.97208601 0.63183302 0.592287 -0.49998301 0.63183302 0.592287 -0.49998301
		 0.63183302 0.592287 -0.49998301 0.63179702 0.59240502 -0.49989 0.63168103 0.59278101
		 -0.49959099 -0.144053 -0.231205 -0.96218097 -0.158768 -0.076316997 -0.98436201 -0.124595
		 -0.25117201 -0.95989001 -0.245924 0.233252 -0.94080502 0.073261999 0.22115301 -0.97248399
		 0.079714999 0.220667 -0.97208601 0.63179702 0.59240502 -0.49989 0.51901799 0.81007802
		 -0.27275199 0.63168103 0.59278101 -0.49959099 0 -0.99984801 0.017452 0 -0.99984801
		 0.017452 0 -0.99984801 0.017452 0 -0.99984801 0.017452 -1 0 0 -1 0 0 -1 0 0 -1 0
		 0 0 -0.017452 -0.99984801 0 -0.017452 -0.99984801 0 -0.017452 -0.99984801 0 -0.017452
		 -0.99984801 1 0 0 1 0 0 1 0 0 1 0 0 0 0.017452 0.99984801 0 0.017452 0.99984801 0
		 0.017452 0.99984801 0 0.017452 0.99984801 0 0.99984801 -0.017452 0 0.99984801 -0.017452
		 0 0.99984801 -0.017452 0 0.99984801 -0.017452 0 -1 0 0 -1 0 0 -1 0 0 -1 0 1 0 0 1
		 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0
		 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0.136829 -0.38352099 -0.91333997 0.27052501 -0.31715199
		 -0.90897202 0.12874199 -0.38721699 -0.912956 0.12874199 -0.38721699 -0.912956 0.124978
		 -0.38892499 -0.91275299 0.124978 -0.38892499 -0.91275299 0.124975 -0.38892499 -0.91275299
		 0.124952 -0.38892099 -0.91275799 0.136829 -0.38352099 -0.91333997 0.124975 -0.38892499
		 -0.91275299;
	setAttr ".n[166:275]" -type "float3"  -0.13224401 -0.33143899 -0.93416297 0.124952
		 -0.38892099 -0.91275799 0 -1 0 0 -1 0 0 -1 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0
		 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0
		 0.14823 -0.37825099 -0.91375798 0.27052501 -0.31715301 -0.90897202 0.132815 -0.38536
		 -0.913158 0.132815 -0.38536 -0.913158 0.124978 -0.38892499 -0.91275299 0.124978 -0.38892499
		 -0.91275299 0.124978 -0.38892499 -0.91275299 0.14823 -0.37825099 -0.91375798 -1 0
		 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 -0.99939102 -0.034899 0 -0.99939102 -0.034899
		 0 -0.99939102 -0.034899 0 -0.99939102 -0.034899 0 -0.99939102 -0.034899 0 -0.034899
		 0.99939102 0 -0.034899 0.99939102 0 -0.034899 0.99939102 0 -0.034899 0.99939102 0
		 0.99939102 0.034899998 0 0.99939102 0.034899998 0 0.99939102 0.034899998 0 0.99939102
		 0.034899998 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 -0.112429 0.013913 -0.99356198 -0.112429
		 0.013913 -0.99356198 -0.112429 0.013913 -0.99356198 -0.112429 0.013913 -0.99356198
		 -0.112429 0.013913 -0.99356198 -0.08918 0.91005999 -0.40476799 0 0.99939102 0.034899998
		 0 0.99939102 0.034899998 -0.08918 0.91005999 -0.40476799 0.40010399 0.463658 -0.79053003
		 0.40010399 0.463658 -0.79053003 0.40010399 0.463658 -0.79053003 0 -1 0 0 -1 0 0 -1
		 0 0 -1 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 -1 0 0
		 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0.022921 0.60204399
		 -0.79813403 0.023574 0.33632299 -0.94145203 0.023574 0.33632299 -0.94145203 0.022924
		 0.60172999 -0.79837 0.022506 0.65234601 -0.75758702 0.022921 0.60204399 -0.79813403
		 0.022924 0.60172999 -0.79837 0.022506 0.65234601 -0.75758702 0.61530399 -0.029579001
		 -0.78773397 0.62732899 0.028205 -0.77824402 0.62462401 0.01423 -0.78079599 0.61530399
		 -0.029579001 -0.78773397 0.62732899 0.028205 -0.77824402 0.65278703 0.33412299 -0.67987603
		 0.65278703 0.33412299 -0.67987603 0.62462401 0.01423 -0.78079599;
	setAttr -s 62 -ch 276 ".fc[0:61]" -type "polyFaces" 
		f 6 0 1 2 3 4 5
		mu 0 6 0 1 2 3 4 5
		f 4 6 7 -6 8
		mu 0 4 6 7 8 9
		f 6 9 10 11 12 -1 -8
		mu 0 6 10 11 12 13 14 15
		f 6 13 -9 -5 14 15 16
		mu 0 6 16 17 18 19 20 21
		f 4 -10 -7 -14 17
		mu 0 4 22 23 24 25
		f 3 -15 -4 18
		mu 0 3 26 27 28
		f 6 -3 19 -12 20 -16 -19
		mu 0 6 28 29 30 31 32 26
		f 4 -11 -18 -17 -21
		mu 0 4 31 33 34 32
		f 3 -2 -13 -20
		mu 0 3 29 35 30
		f 6 21 22 23 24 25 26
		mu 0 6 36 37 38 39 40 41
		f 5 27 -27 28 29 30
		mu 0 5 42 43 44 45 46
		f 4 -28 31 32 -22
		mu 0 4 47 48 49 50
		f 7 -33 33 34 35 36 37 -23
		mu 0 7 51 52 53 54 55 56 57
		f 8 -32 -31 38 39 40 41 42 -34
		mu 0 8 58 59 60 61 62 63 64 65
		f 3 -40 43 44
		mu 0 3 66 67 68
		f 3 -41 -45 45
		mu 0 3 69 66 68
		f 4 -39 -30 46 -44
		mu 0 4 67 70 71 68
		f 4 -42 -46 47 48
		mu 0 4 72 69 68 73
		f 4 -47 -29 -26 49
		mu 0 4 68 71 74 75
		f 4 -35 -43 -49 50
		mu 0 4 76 77 72 73
		f 5 51 -24 -38 52 -48
		mu 0 5 68 78 79 80 73
		f 3 -25 -52 -50
		mu 0 3 75 78 68
		f 3 -36 -51 53
		mu 0 3 81 76 73
		f 3 -37 -54 -53
		mu 0 3 80 81 73
		f 4 54 55 56 57
		mu 0 4 82 83 84 85
		f 4 58 59 -55 60
		mu 0 4 86 87 88 89
		f 4 61 62 -56 -60
		mu 0 4 90 91 92 93
		f 4 63 64 -57 -63
		mu 0 4 94 95 96 97
		f 4 65 -61 -58 -65
		mu 0 4 98 99 100 101
		f 4 -66 -64 -62 -59
		mu 0 4 102 103 104 105
		f 4 66 67 68 69
		mu 0 4 106 107 108 109
		f 5 70 71 -67 72 73
		mu 0 5 110 111 112 113 114
		f 4 74 75 -68 -72
		mu 0 4 115 116 117 118
		f 5 76 77 78 -69 -76
		mu 0 5 119 120 121 122 123
		f 6 -75 -71 79 80 81 -77
		mu 0 6 124 125 126 127 128 129
		f 3 -80 -74 82
		mu 0 3 130 131 132
		f 6 -73 -70 -79 83 -81 -83
		mu 0 6 132 133 134 135 136 130
		f 3 -78 -82 -84
		mu 0 3 135 137 136
		f 4 84 85 86 87
		mu 0 4 138 139 140 141
		f 5 88 89 -85 90 91
		mu 0 5 142 143 144 145 146
		f 4 92 93 -86 -90
		mu 0 4 147 148 149 150
		f 4 -87 -94 94 95
		mu 0 4 151 152 153 154
		f 5 -93 -89 96 97 -95
		mu 0 5 155 156 157 158 159
		f 3 -97 -92 98
		mu 0 3 160 161 162
		f 5 -91 -88 -96 -98 -99
		mu 0 5 162 163 164 165 160
		f 6 99 100 101 102 103 104
		mu 0 6 166 167 168 169 170 171
		f 5 105 -105 106 107 108
		mu 0 5 172 173 174 175 176
		f 4 -106 109 110 -100
		mu 0 4 177 178 179 180
		f 4 -101 -111 111 112
		mu 0 4 181 182 183 184
		f 5 -110 -109 113 114 -112
		mu 0 5 185 186 187 188 189
		f 5 -114 -108 115 -103 116
		mu 0 5 190 191 192 193 194
		f 4 -102 -113 -115 -117
		mu 0 4 194 195 196 190
		f 3 -107 -104 -116
		mu 0 3 192 197 193
		f 4 117 118 119 120
		mu 0 4 198 199 200 201
		f 7 121 122 -118 123 124 125 126
		mu 0 7 202 203 204 205 206 207 208
		f 4 127 128 -119 -123
		mu 0 4 209 210 211 212
		f 7 129 130 131 132 133 -120 -129
		mu 0 7 213 214 215 216 217 218 219
		f 4 -130 -128 -122 134
		mu 0 4 220 221 222 223
		f 4 -124 -121 -134 135
		mu 0 4 224 225 226 227
		f 4 -125 -136 -133 136
		mu 0 4 228 224 227 229
		f 4 -132 137 -126 -137
		mu 0 4 229 230 231 228
		f 4 -131 -135 -127 -138
		mu 0 4 230 232 233 231;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
	setAttr ".bw" 3;
createNode transform -n "breakingcrate_locs";
	rename -uid "090EAFA2-4F06-1A5F-BA83-24B255371E08";
createNode transform -n "breakingcrate_loc1" -p "breakingcrate_locs";
	rename -uid "B8E86939-424E-6F10-6AC9-6A8B9511FD99";
createNode locator -n "breakingcrate_loc1Shape" -p "breakingcrate_loc1";
	rename -uid "7E6BA49C-4512-6808-1A9E-ED961576FFFB";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc1_parentConstraint1" -p "breakingcrate_loc1";
	rename -uid "CA8DD3DB-4ACE-8A55-B00C-45B04C6839A5";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp1W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0.58651542663574208 3.519098393619061 0 ;
	setAttr ".rst" -type "double3" 1.1730308532714844 7.038196437060833 0 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc2" -p "breakingcrate_locs";
	rename -uid "EFD6FC28-4FF3-A940-3FF3-0B8FBBDB57D0";
createNode locator -n "breakingcrate_loc2Shape" -p "breakingcrate_loc2";
	rename -uid "A74556E6-40D6-FA47-BE9E-659315D1DEB1";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc2_parentConstraint1" -p "breakingcrate_loc2";
	rename -uid "D8F69E05-4CBD-5426-4E91-3598DB2B2D44";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp2W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" -0.55867767333984375 -3.814697265625e-006 0 ;
	setAttr ".rst" -type "double3" -10.957788467407227 55.005126953125 36.663144111633301 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc3" -p "breakingcrate_locs";
	rename -uid "083B9E3F-413C-DB00-3956-E39DF79A3443";
createNode locator -n "breakingcrate_loc3Shape" -p "breakingcrate_loc3";
	rename -uid "8BCCE0DE-4B64-D785-B3F1-FC88D5B11B5E";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc3_parentConstraint1" -p "breakingcrate_loc3";
	rename -uid "FA4BA596-4E59-9EEA-9434-83A346E400F8";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp3W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 4.76837158203125e-007 -2.8610229527714637e-006 
		0 ;
	setAttr ".rst" -type "double3" -13.207149505615234 23.346709251403805 36.663144111633301 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc4" -p "breakingcrate_locs";
	rename -uid "5158A197-4534-6099-DBA7-CCA2953C3801";
createNode locator -n "breakingcrate_loc4Shape" -p "breakingcrate_loc4";
	rename -uid "DF7E3A64-4DD4-511D-3593-50A6056E480A";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc4_parentConstraint1" -p "breakingcrate_loc4";
	rename -uid "10CAD1EE-4FE3-9F82-34BC-95919D78045B";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp4W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0.27330398559570313 -4.76837158203125e-006 
		0 ;
	setAttr ".rst" -type "double3" 7.9282169342041016 43.402218818664551 36.663144111633301 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc5" -p "breakingcrate_locs";
	rename -uid "D6074035-494E-7035-99AA-35A17330B4DC";
createNode locator -n "breakingcrate_loc5Shape" -p "breakingcrate_loc5";
	rename -uid "F4D54860-41DC-A10A-F7CA-2C803D82EA67";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc5_parentConstraint1" -p "breakingcrate_loc5";
	rename -uid "B2FABD8D-4E38-ABEE-6E11-EBA2B3215209";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp5W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" -0.04988861083984375 -1.4210854715202004e-014 
		-9.5367431640625e-006 ;
	setAttr ".rst" -type "double3" 8.8519010543823242 82.218948364257798 -0.586517333984375 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc6" -p "breakingcrate_locs";
	rename -uid "4ED49740-4BBA-01D0-DDBD-7BBA4532DF66";
createNode locator -n "breakingcrate_loc6Shape" -p "breakingcrate_loc6";
	rename -uid "830E3313-405A-9012-4364-DBA0143195BE";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc6_parentConstraint1" -p "breakingcrate_loc6";
	rename -uid "E0B6D2E9-408A-D971-59A0-20B4F832E91B";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp6W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 -2.6226043701171875e-006 0.091501712799072266 ;
	setAttr ".rst" -type "double3" 37.029716491699219 43.402213335037231 12.228683948516846 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc7" -p "breakingcrate_locs";
	rename -uid "4D0134B1-4211-077E-7787-F6A8B62FC395";
createNode locator -n "breakingcrate_loc7Shape" -p "breakingcrate_loc7";
	rename -uid "203AEC4D-4F57-382C-DE17-3C91D15BDE93";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc7_parentConstraint1" -p "breakingcrate_loc7";
	rename -uid "21F530DA-4181-7EA9-7E4B-C78C4DE739AB";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp7W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 1.1920928955078125e-006 -0.54961442947387695 ;
	setAttr ".rst" -type "double3" 37.029716491699219 43.402213335037231 -14.332284450531006 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc8" -p "breakingcrate_locs";
	rename -uid "C6BA2221-4FAA-0834-A83B-04AD2536BA90";
createNode locator -n "breakingcrate_loc8Shape" -p "breakingcrate_loc8";
	rename -uid "D8314E4B-4EEA-5184-74B3-88A1FB975040";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc8_parentConstraint1" -p "breakingcrate_loc8";
	rename -uid "5264DA84-453F-0836-AB2F-5199C6DDCEDE";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp8W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" -1.9073486328125e-006 9.5367431640625e-007 
		0 ;
	setAttr ".rst" -type "double3" 7.1549749374389648 43.402216911315918 -36.956401824951172 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc9" -p "breakingcrate_locs";
	rename -uid "496A8DE4-4E63-AA78-64F8-64AD378F19C2";
createNode locator -n "breakingcrate_loc9Shape" -p "breakingcrate_loc9";
	rename -uid "75102F89-44EA-52E6-E80F-F3BBEB593B4E";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc9_parentConstraint1" -p "breakingcrate_loc9";
	rename -uid "DBAA71EF-4400-CE10-0B2D-7CA7A4842D6E";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp9W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" -0.034568548202511096 2.1457672083613488e-006 
		7.1054273576010019e-015 ;
	setAttr ".rst" -type "double3" -17.808063745498654 25.081090211868283 -37.249660491943352 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc10" -p "breakingcrate_locs";
	rename -uid "5DD549D7-437C-7D12-2788-2AB81BF44A53";
createNode locator -n "breakingcrate_loc10Shape" -p "breakingcrate_loc10";
	rename -uid "E953AA46-449F-27D0-F432-27909ECA1066";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc10_parentConstraint1" -p "breakingcrate_loc10";
	rename -uid "A5A2FDDC-44E8-337D-101B-D4A025C1D00A";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp10W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 2.86102294921875e-006 0.012138366699225855 
		0 ;
	setAttr ".rst" -type "double3" -6.5793962478637695 58.13042068481446 -36.956401824951172 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc11" -p "breakingcrate_locs";
	rename -uid "B2CDFEDF-45AD-8BC0-0EA4-1B909AAA7523";
createNode locator -n "breakingcrate_loc11Shape" -p "breakingcrate_loc11";
	rename -uid "D7F55BC8-460F-890E-5D9A-BC99AB149FE8";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc11_parentConstraint1" -p "breakingcrate_loc11";
	rename -uid "8BC8AF96-45AE-46B0-3903-84B838A03FB3";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp11W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" -0.89522075653076172 0.043659210205078125 1.9073486328125e-006 ;
	setAttr ".rst" -type "double3" -9.5819339752197266 82.25341796875 -0.0014324188232421875 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc12" -p "breakingcrate_locs";
	rename -uid "6EEF4F60-4FAA-ED76-BAFD-18BF15B42DAE";
createNode locator -n "breakingcrate_loc12Shape" -p "breakingcrate_loc12";
	rename -uid "66647501-40E8-EAB0-AF53-04AF52974DE5";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc12_parentConstraint1" -p "breakingcrate_loc12";
	rename -uid "A7E3A3D7-495F-8C32-E676-289CC0A64F38";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp12W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 1.1920928955078125e-006 -0.81140756607055664 ;
	setAttr ".rst" -type "double3" -36.44320011138916 43.402213335037231 -14.213162899017334 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_loc13" -p "breakingcrate_locs";
	rename -uid "B47163EF-43C2-4E1C-FD4F-F688EA0B549E";
createNode locator -n "breakingcrate_loc13Shape" -p "breakingcrate_loc13";
	rename -uid "9D19C41D-4EA3-1819-7D4A-FDAF2D0B8360";
	setAttr -k off ".v";
createNode parentConstraint -n "breakingcrate_loc13_parentConstraint1" -p "breakingcrate_loc13";
	rename -uid "362D574F-4B58-02B3-D2AA-A2BF5ADEBEA6";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "breakingcrate_physics_grp13W0" -dv 
		1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".tg[0].tot" -type "double3" 0 6.9141387939453125e-006 0.30335521697998225 ;
	setAttr ".rst" -type "double3" -36.44320011138916 43.402213335037231 9.9553966522216815 ;
	setAttr -k on ".w0";
createNode transform -n "breakingcrate_physics";
	rename -uid "DDF44888-4868-0714-08D7-C7936BE30412";
createNode transform -n "breakingcrate_physics_grp1" -p "breakingcrate_physics";
	rename -uid "6E469DAA-4008-0F51-457E-DB93D5F3B8C8";
	setAttr ".rp" -type "double3" 0.58651542663574219 3.5190980434417725 0 ;
	setAttr ".sp" -type "double3" 0.58651542663574219 3.5190980434417725 0 ;
createNode mesh -n "breakingcrate_physics_grp1Shape" -p "breakingcrate_physics_grp1";
	rename -uid "FB6F2EC5-49C4-EC00-C681-BBA700E8AAF5";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 12 ".vt[0:11]"  34.75110245 -0.1305027 37.44439697 -36.55757141 7.16869831 37.10754395
		 37.73060226 7.16869879 -37.10974884 -36.55757141 7.16869831 -37.10753632 37.73059845 7.16869831 37.10974121
		 -32.99155045 -0.13050222 -37.44238281 -32.99154282 -0.13050199 37.44238281 -36.55757523 3.68185568 -37.26744843
		 -36.55757141 3.68185568 37.26744843 37.73060608 3.6818471 37.26965332 37.73059845 3.6818471 -37.26965332
		 34.75110245 -0.13050199 -37.44439697;
	setAttr -s 18 ".ed[0:17]"  4 2 1 2 3 1 3 1 1 1 4 1 6 5 1 5 11 1 11 0 1
		 0 6 1 8 7 1 7 5 1 6 8 1 9 4 1 1 8 1 0 9 1 10 9 1 11 10 1 7 3 1 2 10 1;
	setAttr -s 8 -ch 36 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 6 7
		f 4 8 9 -5 10
		f 6 11 -4 12 -11 -8 13
		f 4 14 -14 -7 15
		f 6 -16 -6 -10 16 -2 17
		f 4 -18 -1 -12 -15
		f 4 -13 -3 -17 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp2" -p "breakingcrate_physics";
	rename -uid "363BD62B-4715-A986-7472-46969F0F070B";
	setAttr ".rp" -type "double3" -10.399110794067383 55.005130767822266 36.663144111633301 ;
	setAttr ".sp" -type "double3" -10.399110794067383 55.005130767822266 36.663144111633301 ;
createNode transform -n "breakingcrate_geo8_physics" -p "breakingcrate_physics_grp2";
	rename -uid "8A977CF5-4FE9-2ED1-C150-C59DEB03CA83";
createNode mesh -n "breakingcrate_geo8_physicsShape" -p "breakingcrate_geo8_physics";
	rename -uid "3828059E-43B3-61BF-D95F-33AA09DF508E";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -37.53704834 28.90206146 36.65727615 17.70223618 33.3679657 36.65727615
		 9.39053726 28.90206146 31.67188835 9.83545303 44.41249466 31.67188835 -37.53705215 44.41249466 36.65727615
		 14.88460159 44.41249466 36.65727615 -37.53705215 28.90206146 31.67188835 12.93887329 28.90206146 36.65727615
		 12.94277191 32.23246765 31.67188835 -37.53705597 44.41249466 31.67188835;
	setAttr -s 15 ".ed[0:14]"  5 3 1 3 9 1 9 4 1 4 5 1 6 0 1 0 4 1 9 6 1
		 7 1 1 1 5 1 0 7 1 8 3 1 1 8 1 7 2 1 2 8 1 2 6 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -3 6
		f 5 7 8 -4 -6 9
		f 4 10 -1 -9 11
		f 4 -12 -8 12 13
		f 5 -14 14 -7 -2 -11
		f 4 -10 -5 -15 -13;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo9_physics" -p "breakingcrate_physics_grp2";
	rename -uid "69C56487-4322-AAE1-C90B-D89A3D710E9C";
createNode mesh -n "breakingcrate_geo9_physicsShape" -p "breakingcrate_geo9_physics";
	rename -uid "DF8B69D9-4D12-30D8-71CC-20B0FD2AB1A6";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 12 ".vt[0:11]"  -23.45405197 80.74463654 41.65439987 -37.33800125 81.10820007 37.52531815
		 -24.62218857 36.13528061 37.52531815 -38.39451218 40.76173401 37.52531815 -37.33800125 81.10820007 41.65439987
		 -38.50045776 36.71596146 41.65439987 -23.45405197 80.74462891 37.52531815 -24.57153702 38.069656372 41.65439987
		 -36.5842514 37.81843567 37.52531815 -26.37794876 34.39096832 37.52531815 -38.48300934 37.38215256 40.065055847
		 -29.10873032 33.56204224 41.65439987;
	setAttr -s 18 ".ed[0:17]"  7 2 1 2 6 1 6 0 1 0 7 1 0 4 1 4 5 1 5 11 1
		 11 7 1 9 8 1 8 3 1 3 1 1 1 6 1 2 9 1 11 9 1 10 8 1 5 10 1 4 1 1 3 10 1;
	setAttr -s 8 -ch 36 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 5 -4 4 5 6 7
		f 6 8 9 10 11 -2 12
		f 4 -13 -1 -8 13
		f 5 14 -9 -14 -7 15
		f 5 -16 -6 16 -11 17
		f 3 -18 -10 -15
		f 4 -12 -17 -5 -3;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo10_physics" -p "breakingcrate_physics_grp2";
	rename -uid "B383CC57-4331-1005-3E8F-76A823FE659C";
createNode mesh -n "breakingcrate_geo10_physicsShape" -p "breakingcrate_geo10_physics";
	rename -uid "B19ABFAD-4A96-80EB-945B-9984D951E040";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -37.53705215 44.73800659 36.65727615 7.62560177 55.37675476 36.65727615
		 2.51005745 44.73800659 31.67188835 3.81856823 60.24843597 31.67188835 -37.53705215 60.24843597 36.65727615
		 -37.53705215 44.73800659 31.67188835 0.9256916 44.73800659 36.65727615 5.2898531 60.24843597 36.65727615
		 7.47510624 52.62197876 31.67188835 -37.53705215 60.24843597 31.67188835;
	setAttr -s 15 ".ed[0:14]"  5 0 1 0 4 1 4 9 1 9 5 1 6 0 1 5 2 1 2 6 1
		 7 4 1 6 1 1 1 7 1 8 3 1 3 7 1 1 8 1 2 8 1 9 3 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -1 5 6
		f 5 7 -2 -5 8 9
		f 4 10 11 -10 12
		f 4 -13 -9 -7 13
		f 5 -14 -6 -4 14 -11
		f 4 -12 -15 -3 -8;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo11_physics" -p "breakingcrate_physics_grp2";
	rename -uid "2FB40BC2-4751-4F16-18A2-51A4D6C3BC60";
createNode mesh -n "breakingcrate_geo11_physicsShape" -p "breakingcrate_geo11_physics";
	rename -uid "BDEF62BB-4921-6656-0F1D-3FBA6D3A2EFF";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -23.16739655 73.22071075 36.059028625 8.0936203 59.33200455 40.18811035
		 -1.093849182 73.22071075 40.18811035 -23.16739655 59.33200455 36.059028625 6.59371185 59.33200455 36.059028625
		 -23.16739655 73.22071075 40.18811035 -2.5937562 73.22071075 36.059028625 -23.16739655 59.33200455 40.18811035;
	setAttr -s 12 ".ed[0:11]"  5 0 1 0 3 1 3 7 1 7 5 1 7 1 1 1 2 1 2 5 1
		 6 4 1 4 3 1 0 6 1 2 6 1 1 4 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 7 8 -2 9
		f 4 -10 -1 -7 10
		f 4 -11 -6 11 -8
		f 4 -12 -5 -3 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo12_physics" -p "breakingcrate_physics_grp2";
	rename -uid "982F0E43-4C3F-3B77-FC70-869727544E87";
createNode mesh -n "breakingcrate_geo12_physicsShape" -p "breakingcrate_geo12_physics";
	rename -uid "88DF1ACA-4794-251D-CE18-C6B6395ED587";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 9 ".vt[0:8]"  -2.86395264 63.21327209 36.65727615 -37.53705597 63.21326828 36.65727615
		 -37.53705597 78.72370148 36.65727615 -11.012020111 78.72370148 36.65727615 -7.3719883 63.21327209 31.67188835
		 -37.53705597 63.21327209 31.67188835 -12.52528858 78.72370148 31.67188835 -3.13006973 63.21327209 35.78056717
		 -37.53705597 78.72370148 31.67188835;
	setAttr -s 14 ".ed[0:13]"  3 2 1 2 1 1 1 0 1 0 3 1 6 4 1 4 5 1 5 8 1
		 8 6 1 8 2 1 3 6 1 7 6 1 0 7 1 1 5 1 4 7 1;
	setAttr -s 7 -ch 28 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 6 7
		f 4 -8 8 -1 9
		f 4 10 -10 -4 11
		f 5 -12 -3 12 -6 13
		f 3 -14 -5 -11
		f 4 -13 -2 -9 -7;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp3" -p "breakingcrate_physics";
	rename -uid "8BB7DCA3-4D28-452F-7942-E4944122B0FC";
	setAttr ".rp" -type "double3" -13.207149982452393 23.346712112426758 36.663144111633301 ;
	setAttr ".sp" -type "double3" -13.207149982452393 23.346712112426758 36.663144111633301 ;
createNode transform -n "breakingcrate_geo13_physics" -p "breakingcrate_physics_grp3";
	rename -uid "FA8AD6CA-43A9-EC28-ECBB-D7A854B7AE3A";
createNode mesh -n "breakingcrate_geo13_physicsShape" -p "breakingcrate_geo13_physics";
	rename -uid "ACE95423-4382-1FE7-1454-099B3D21C4B2";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -25.15168571 30.69826889 40.18811035 -1.61292458 16.80956459 36.99898911
		 -25.15168571 16.80956268 40.18811035 -16.50881386 30.69826889 36.059028625 -25.15168571 30.69826889 35.48972321
		 -2.49291039 16.80956268 40.18811035 -17.64816666 30.69826889 40.18811035 -25.15168571 16.80956459 35.44848633;
	setAttr -s 12 ".ed[0:11]"  4 3 1 3 1 1 1 7 1 7 4 1 7 2 1 2 0 1 0 4 1
		 6 5 1 5 1 1 3 6 1 0 6 1 2 5 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 7 8 -2 9
		f 4 -10 -1 -7 10
		f 4 -11 -6 11 -8
		f 4 -12 -5 -3 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo14_physics" -p "breakingcrate_physics_grp3";
	rename -uid "FE1C25D5-45B2-E23E-AF08-9D94033712C1";
createNode mesh -n "breakingcrate_geo14_physicsShape" -p "breakingcrate_geo14_physics";
	rename -uid "755D980E-479C-B700-296B-C5A3491362B2";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 11 ".vt[0:10]"  -37.53705597 7.20095158 36.65727615 12.88891506 12.50097752 36.65727615
		 10.0053853989 7.20095205 31.67188835 -4.15605879 22.71138382 31.67188835 -37.53705597 22.71138573 36.65727615
		 -37.53705597 7.20095205 31.67188835 -4.75913668 22.71138382 36.65727615 10.84905529 7.20095205 36.65727615
		 10.3240881 8.02901268 31.67188835 -2.57606316 21.79726791 31.67188835 -37.53705597 22.71138763 31.67188835;
	setAttr -s 17 ".ed[0:16]"  5 0 1 0 4 1 4 10 1 10 5 1 6 3 1 3 10 1 4 6 1
		 7 1 1 1 6 1 0 7 1 8 1 1 7 2 1 2 8 1 9 8 1 2 5 1 3 9 1 1 9 1;
	setAttr -s 8 -ch 34 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -3 6
		f 5 7 8 -7 -2 9
		f 4 10 -8 11 12
		f 6 13 -13 14 -4 -6 15
		f 4 -16 -5 -9 16
		f 3 -17 -11 -14
		f 4 -10 -1 -15 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo15_physics" -p "breakingcrate_physics_grp3";
	rename -uid "6E544DDD-4FD3-FEDB-3382-44AEB3AC4CEC";
createNode mesh -n "breakingcrate_geo15_physicsShape" -p "breakingcrate_geo15_physics";
	rename -uid "43F07216-4B82-D123-29DB-BD903C24502E";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -39.30321121 6.059810638 41.65439987 -38.38834381 40.99717712 37.52531815
		 -24.5715332 38.069656372 41.65439987 -39.30321503 6.059809685 37.52531815 -25.41926193 5.6962471 41.65439987
		 -24.62218666 36.13528442 37.52531815 -38.49636459 36.87219238 41.65439987 -25.41926193 5.6962471 37.52531815;
	setAttr -s 13 ".ed[0:12]"  5 2 1 2 4 1 4 7 1 7 5 1 7 3 1 3 1 1 1 5 1
		 1 2 1 6 2 1 1 6 1 3 0 1 0 6 1 0 4 1;
	setAttr -s 7 -ch 26 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 3 -7 7 -1
		f 3 8 -8 9
		f 4 -10 -6 10 11
		f 4 -12 12 -2 -9
		f 4 -13 -11 -5 -3;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp4" -p "breakingcrate_physics";
	rename -uid "A027244A-45AE-91CE-F464-A4B99E853D8F";
	setAttr ".rp" -type "double3" 7.6549129486083984 43.402223587036133 36.663144111633301 ;
	setAttr ".sp" -type "double3" 7.6549129486083984 43.402223587036133 36.663144111633301 ;
createNode transform -n "breakingcrate_geo16_physics" -p "breakingcrate_physics_grp4";
	rename -uid "95DA5CF5-422F-25B7-C6B4-19AFE9987B50";
createNode mesh -n "breakingcrate_geo16_physicsShape" -p "breakingcrate_geo16_physics";
	rename -uid "E9B94120-4D9F-FA56-D112-2DA33CA3D220";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  24.047174454 73.22071075 36.059028625 6.48679018 59.33200455 40.18811035
		 24.047172546 73.22071075 40.18811035 24.047172546 59.33200455 36.059028625 4.894629 59.33200455 36.059028625
		 24.047172546 59.33200836 40.18811035 -2.47502804 73.22071075 40.18811035 -4.067193985 73.22071075 36.059028625;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 0 1 0 3 1 3 4 1 5 3 1 0 2 1 2 5 1
		 6 2 1 7 6 1 4 1 1 1 6 1 1 5 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -3 5 6
		f 4 7 -6 -2 8
		f 4 -9 -1 9 10
		f 4 -11 11 -7 -8
		f 4 -12 -10 -4 -5;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo17_physics" -p "breakingcrate_physics_grp4";
	rename -uid "74E0850C-4BC2-DCEA-6647-0F84AC0DFC79";
createNode mesh -n "breakingcrate_geo17_physicsShape" -p "breakingcrate_geo17_physics";
	rename -uid "E529BC17-41FF-27A6-03EC-26BA94371111";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  37.53705215 78.72370148 36.65727615 37.53705215 63.21327209 31.67188835
		 -2.86395836 63.21327209 36.65727615 -11.28984928 78.72370148 36.65727615 37.53705215 78.72370148 31.67188835
		 37.53705215 63.21327209 36.65727615 -12.5317812 78.72370148 31.67188835 -8.16817188 63.21327209 31.67188835
		 -11.77955151 71.5574646 36.65727615 -13.26566601 67.98406982 31.67188835;
	setAttr -s 15 ".ed[0:14]"  5 1 1 1 4 1 4 0 1 0 5 1 6 3 1 3 0 1 4 6 1
		 7 9 1 9 6 1 1 7 1 8 3 1 9 8 1 7 2 1 2 8 1 2 5 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -3 6
		f 5 7 8 -7 -2 9
		f 4 10 -5 -9 11
		f 4 -12 -8 12 13
		f 5 -14 14 -4 -6 -11
		f 4 -10 -1 -15 -13;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo18_physics" -p "breakingcrate_physics_grp4";
	rename -uid "3E033F0E-4024-2EA9-F2FC-CFA5B9CC5BC2";
createNode mesh -n "breakingcrate_geo18_physicsShape" -p "breakingcrate_geo18_physics";
	rename -uid "C211D88B-464D-1AD6-4C73-B781AB758D56";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  37.53705215 60.24843597 31.67188835 37.53705215 44.73800659 36.65727615
		 4.093196869 60.24843597 36.65727615 0.48844337 44.73800659 36.65727615 37.53704834 44.73800659 31.67188835
		 37.53705215 60.24843597 36.65727615 3.81856728 60.24843597 31.67188835 0.21381569 44.73800659 31.67188835;
	setAttr -s 12 ".ed[0:11]"  5 2 1 2 3 1 3 1 1 1 5 1 1 4 1 4 0 1 0 5 1
		 6 2 1 0 6 1 4 7 1 7 6 1 7 3 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 7 -1 -7 8
		f 4 -9 -6 9 10
		f 4 -11 11 -2 -8
		f 4 -5 -3 -12 -10;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo19_physics" -p "breakingcrate_physics_grp4";
	rename -uid "F890441B-49DF-87ED-CBEC-9AA30517EC56";
createNode mesh -n "breakingcrate_geo19_physicsShape" -p "breakingcrate_geo19_physics";
	rename -uid "E32279F9-4268-0C99-E748-46B13DE58AD9";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  36.45822525 81.10820007 37.52531815 38.42343521 6.059810638 41.65439987
		 22.57427406 80.74462891 41.65439987 38.42343521 6.059806824 37.52531815 22.57427406 80.74462891 37.52531815
		 36.45822525 81.10819244 41.65439987 24.53948593 5.69625092 41.65439987 24.53948593 5.6962471 37.52531815;
	setAttr -s 12 ".ed[0:11]"  4 0 1 0 3 1 3 7 1 7 4 1 5 1 1 1 3 1 0 5 1
		 6 2 1 2 4 1 7 6 1 1 6 1 5 2 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 8 -4 9
		f 4 -10 -3 -6 10
		f 4 -11 -5 11 -8
		f 4 -7 -1 -9 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo20_physics" -p "breakingcrate_physics_grp4";
	rename -uid "77B3CE85-45A9-C3C7-9C28-4C8D5EA70C0E";
createNode mesh -n "breakingcrate_geo20_physicsShape" -p "breakingcrate_geo20_physics";
	rename -uid "3BAC9B31-4025-99A7-98A7-E386CA53AB02";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  37.53705215 44.41249466 36.65727615 37.53705215 28.90206146 31.67188835
		 12.32583237 28.90206146 36.65727615 8.62332535 44.41249847 31.67188835 37.53705215 44.41249466 31.67188835
		 37.53705215 28.90206146 36.65727615 13.19886875 44.41249466 36.65727615 7.75029373 28.90206146 31.67188835;
	setAttr -s 12 ".ed[0:11]"  5 2 1 2 7 1 7 1 1 1 5 1 1 4 1 4 0 1 0 5 1
		 6 3 1 3 7 1 2 6 1 0 6 1 4 3 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 7 8 -2 9
		f 4 -10 -1 -7 10
		f 4 -11 -6 11 -8
		f 4 -5 -3 -9 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo21_physics" -p "breakingcrate_physics_grp4";
	rename -uid "ABE9FEA5-4250-4835-5E47-F6BC139ADA21";
createNode mesh -n "breakingcrate_geo21_physicsShape" -p "breakingcrate_geo21_physics";
	rename -uid "4BBD3220-4FE1-FE6A-2946-25BC3607D8CD";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 12 ".vt[0:11]"  24.047176361 30.69826889 36.059028625 24.047174454 16.80956268 40.18811035
		 -18.18652725 30.69826889 40.18811035 -5.5508132 16.80956268 40.18811035 24.047168732 16.80956268 36.059028625
		 -16.5990448 16.80956078 36.059028625 24.047168732 30.69826889 40.18811035 -17.5889473 30.69826889 36.059028625
		 -22.022111893 24.33014297 40.18811035 -21.7247963 19.14991379 36.059028625 -22.30057335 25.15237999 40.18811035
		 -23.11360931 23.25081444 36.059028625;
	setAttr -s 18 ".ed[0:17]"  5 4 1 4 1 1 1 3 1 3 5 1 7 2 1 2 6 1 6 0 1
		 0 7 1 9 11 1 11 7 1 0 4 1 5 9 1 3 8 1 8 9 1 10 8 1 1 6 1 2 10 1 11 10 1;
	setAttr -s 8 -ch 36 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 6 7
		f 6 8 9 -8 10 -1 11
		f 4 -12 -4 12 13
		f 6 14 -13 -3 15 -6 16
		f 4 -17 -5 -10 17
		f 4 -18 -9 -14 -15
		f 4 -16 -2 -11 -7;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo22_physics" -p "breakingcrate_physics_grp4";
	rename -uid "5EB914F6-45E9-A8A8-1492-2F9E4DC43EBA";
createNode mesh -n "breakingcrate_geo22_physicsShape" -p "breakingcrate_geo22_physics";
	rename -uid "8A9F430B-4ACC-2362-B651-AAA6F02F8D4D";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  37.53705597 22.71138763 36.65727615 37.53705215 7.20095253 31.67188835
		 10.81554794 7.20095253 36.65727615 -4.75914383 22.71138763 36.65727615 37.53705215 22.71138763 31.67188835
		 37.53705215 7.20095253 36.65727615 8.16662884 7.20095253 31.67188835 -4.15606499 22.71138763 31.67188835
		 -5.21817017 21.21343613 36.65727615 -5.30203438 18.97173691 31.67188835;
	setAttr -s 15 ".ed[0:14]"  5 1 1 1 4 1 4 0 1 0 5 1 6 1 1 5 2 1 2 6 1
		 7 4 1 6 9 1 9 7 1 8 3 1 3 7 1 9 8 1 2 8 1 0 3 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -1 5 6
		f 5 7 -2 -5 8 9
		f 4 10 11 -10 12
		f 4 -13 -9 -7 13
		f 5 -14 -6 -4 14 -11
		f 4 -12 -15 -3 -8;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp5" -p "breakingcrate_physics";
	rename -uid "84BBB6D7-4C00-CF1F-7169-E1AFD7571C79";
	setAttr ".rp" -type "double3" 8.901789665222168 82.218948364257813 -0.58650779724121094 ;
	setAttr ".sp" -type "double3" 8.901789665222168 82.218948364257813 -0.58650779724121094 ;
createNode transform -n "breakingcrate_geo23_physics" -p "breakingcrate_physics_grp5";
	rename -uid "F4022362-4A3C-1089-5C2B-E1A3CEFFDA70";
createNode mesh -n "breakingcrate_geo23_physicsShape" -p "breakingcrate_geo23_physics";
	rename -uid "AD3414C5-40A3-510E-914D-929DF76D8EA3";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  37.73060226 78.75595856 36.80390549 37.73060226 82.24280548 21.5544796
		 -9.85165024 78.75595856 21.55448151 -10.004108429 82.24280548 21.5544796 37.73060226 82.24280548 36.80390549
		 37.73060226 78.75595856 21.5544796 -11.10275269 78.75595856 34.75520706 -4.50597858 78.75595856 36.80390549
		 -11.37503052 80.54244232 36.80390549 -11.44937897 82.24280548 36.80390549;
	setAttr -s 15 ".ed[0:14]"  5 2 1 2 3 1 3 1 1 1 5 1 1 4 1 4 0 1 0 5 1
		 7 6 1 6 2 1 0 7 1 8 7 1 4 9 1 9 8 1 9 3 1 6 8 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 5 7 8 -1 -7 9
		f 5 10 -10 -6 11 12
		f 5 -13 13 -2 -9 14
		f 3 -15 -8 -11
		f 4 -5 -3 -14 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo24_physics" -p "breakingcrate_physics_grp5";
	rename -uid "1A336062-454F-0889-10F7-0D9AA666F248";
createNode mesh -n "breakingcrate_geo24_physicsShape" -p "breakingcrate_geo24_physics";
	rename -uid "9065D9C2-4391-5A0A-C471-08BDC157EB31";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 12 ".vt[0:11]"  39.48353195 82.69886017 2.38258648 38.98458481 78.38273621 21.26692772
		 -19.43869972 81.93295288 19.89060783 -14.51313591 79.11333466 8.11379623 38.98458481 81.8677063 21.41908264
		 39.48202896 79.21138 2.28788567 -0.26251459 82.51074982 6.66790676 -17.41228676 82.1170578 15.67495823
		 -19.78577423 81.9537735 19.4135437 -21.3702774 78.45167542 19.68798256 -14.60593224 78.95676422 8.11955452
		 -21.67995262 78.47026062 19.26232338;
	setAttr -s 18 ".ed[0:17]"  5 0 1 0 4 1 4 1 1 1 5 1 7 6 1 6 3 1 3 7 1
		 9 2 1 2 8 1 8 11 1 11 9 1 9 1 1 4 2 1 10 5 1 11 10 1 8 7 1 3 10 1 6 0 1;
	setAttr -s 8 -ch 36 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 3 4 5 6
		f 4 7 8 9 10
		f 4 11 -3 12 -8
		f 5 13 -4 -12 -11 14
		f 5 -15 -10 15 -7 16
		f 5 -17 -6 17 -1 -14
		f 6 -9 -13 -2 -18 -5 -16;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo25_physics" -p "breakingcrate_physics_grp5";
	rename -uid "8FC53077-496D-F1CE-652A-D4BB630A65C2";
createNode mesh -n "breakingcrate_geo25_physicsShape" -p "breakingcrate_geo25_physics";
	rename -uid "9045519F-4FEE-91E7-BC0E-E090B5A38004";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  33.18965149 82.5683136 38.21113205 35.13428879 82.5683136 -38.96300888
		 19.89008522 82.5683136 -39.38414383 17.94544983 86.055160522 37.78998566 35.13428879 86.055160522 -38.96300888
		 33.18965149 86.055160522 38.21113205 17.94544983 82.5683136 37.78998947 19.89008522 86.055160522 -39.38414764;
	setAttr -s 12 ".ed[0:11]"  4 1 1 1 2 1 2 7 1 7 4 1 5 4 1 7 3 1 3 5 1
		 6 3 1 2 6 1 1 0 1 0 6 1 0 5 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -4 5 6
		f 4 7 -6 -3 8
		f 4 -9 -2 9 10
		f 4 -11 11 -7 -8
		f 4 -12 -10 -1 -5;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo26_physics" -p "breakingcrate_physics_grp5";
	rename -uid "E4C80C70-463B-1E70-E3FA-A1A214531BFA";
createNode mesh -n "breakingcrate_geo26_physicsShape" -p "breakingcrate_geo26_physics";
	rename -uid "1A771882-482B-FAD8-555E-0AAE22FE6A34";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  37.73060226 78.75595856 4.093884468 37.73060608 82.24280548 -6.73320961
		 0.70036888 78.75595856 -6.73321056 37.73060226 82.24280548 4.093883514 37.73060226 78.75595856 -6.73320961
		 0.47266388 82.24280548 4.093883514 2.70578575 82.24280548 -6.73320961 -1.53275299 78.75595856 4.093885422;
	setAttr -s 12 ".ed[0:11]"  4 1 1 1 3 1 3 0 1 0 4 1 5 7 1 7 0 1 3 5 1
		 6 5 1 1 6 1 4 2 1 2 6 1 2 7 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -3 6
		f 4 7 -7 -2 8
		f 4 -9 -1 9 10
		f 4 -11 11 -5 -8
		f 4 -4 -6 -12 -10;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo27_physics" -p "breakingcrate_physics_grp5";
	rename -uid "C8C75CE8-4F64-3C29-7749-E7A329A1AF1D";
createNode mesh -n "breakingcrate_geo27_physicsShape" -p "breakingcrate_geo27_physics";
	rename -uid "8DC07DFD-4015-079C-FEE1-99B8FC8DC100";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  38.37358856 82.24280548 -8.20717144 2.48315239 78.75595856 -21.16146851
		 4.56423664 78.75595856 -7.91212177 38.25782013 78.75595856 -21.47366714 38.25782013 82.24280548 -21.47366714
		 38.37358856 78.75595856 -8.20717144 4.045116425 82.24280548 -21.17509842 -0.77417564 82.24280548 -7.86553574;
	setAttr -s 13 ".ed[0:12]"  5 3 1 3 4 1 4 0 1 0 5 1 0 7 1 7 2 1 2 5 1
		 2 1 1 1 3 1 6 4 1 1 6 1 1 7 1 7 6 1;
	setAttr -s 7 -ch 26 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 -7 7 8 -1
		f 4 9 -2 -9 10
		f 3 -11 11 12
		f 4 -13 -5 -3 -10
		f 3 -6 -12 -8;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo28_physics" -p "breakingcrate_physics_grp5";
	rename -uid "FB6FAE34-489F-8531-28D3-359CD1C09E12";
createNode mesh -n "breakingcrate_geo28_physicsShape" -p "breakingcrate_geo28_physics";
	rename -uid "2D1751E9-4A60-00BD-B2EB-D4BB0A719F2B";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  37.73060226 82.24280548 -37.39042282 37.73060226 78.75595856 -22.14099503
		 3.78695965 82.24280548 -22.14099503 16.30308151 82.24280548 -37.39042282 37.73059845 78.75595856 -37.39042282
		 37.73060226 82.24280548 -22.14099503 17.39370346 78.75595856 -37.39042282 3.4521656 82.24280548 -26.53710175
		 1.84541702 78.75595856 -22.14099503 1.69386292 78.75595856 -24.13102531;
	setAttr -s 15 ".ed[0:14]"  5 1 1 1 4 1 4 0 1 0 5 1 7 3 1 3 6 1 6 9 1
		 9 7 1 7 2 1 2 5 1 0 3 1 8 2 1 9 8 1 6 4 1 1 8 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 6 7
		f 5 8 9 -4 10 -5
		f 4 11 -9 -8 12
		f 5 -13 -7 13 -2 14
		f 4 -15 -1 -10 -12
		f 4 -6 -11 -3 -14;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp6" -p "breakingcrate_physics";
	rename -uid "92787B46-4068-A8E2-5D97-AC9A87FE1A66";
	setAttr ".rp" -type "double3" 37.029716491699219 43.402215957641602 12.137182235717773 ;
	setAttr ".sp" -type "double3" 37.029716491699219 43.402215957641602 12.137182235717773 ;
createNode transform -n "breakingcrate_geo29_physics" -p "breakingcrate_physics_grp6";
	rename -uid "421AF167-4565-3CDC-04CC-D78C10870979";
createNode mesh -n "breakingcrate_geo29_physicsShape" -p "breakingcrate_geo29_physics";
	rename -uid "743E3C5D-49BA-146B-F28A-6BA5537AE772";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  32.11177444 78.72370148 31.25765991 37.097164154 63.21327209 31.257658
		 32.11177444 63.21327209 -10.86171722 37.097164154 78.72370148 31.25765419 32.11177444 63.21327209 31.25765991
		 37.097164154 63.21327209 -10.59526062 32.11177444 78.72370148 -11.53669167 37.097164154 65.97457886 -13.50898552
		 32.11177444 63.66569901 -11.33911705 37.097164154 78.72370148 -13.67626953;
	setAttr -s 15 ".ed[0:14]"  4 1 1 1 3 1 3 0 1 0 4 1 6 0 1 3 9 1 9 6 1
		 7 9 1 1 5 1 5 7 1 8 7 1 5 2 1 2 8 1 2 4 1 6 8 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -3 5 6
		f 5 7 -6 -2 8 9
		f 4 10 -10 11 12
		f 5 -13 13 -4 -5 14
		f 4 -15 -7 -8 -11
		f 4 -9 -1 -14 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo30_physics" -p "breakingcrate_physics_grp6";
	rename -uid "71E403B5-41F1-73FA-FCA7-D38B03F2FFB0";
createNode mesh -n "breakingcrate_geo30_physicsShape" -p "breakingcrate_geo30_physics";
	rename -uid "EF821360-4638-3534-8659-6BACF2DE2AB7";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 12 ".vt[0:11]"  35.76576996 73.22071075 23.60728455 39.89485168 59.33200455 23.60728645
		 35.76576996 59.33200455 0.75242972 39.89485168 59.33200455 -1.4082303 39.89485168 73.22071075 23.60728264
		 35.76576996 59.33200455 23.60728455 39.89485168 73.22071075 -8.23316956 39.89485168 69.67295074 -8.14879227
		 35.76576996 73.22071075 -8.039920807 35.76576996 72.96040344 -8.13100052 36.80581665 73.22071075 -8.84491158
		 36.87352371 73.22071075 -8.88034058;
	setAttr -s 18 ".ed[0:17]"  5 2 1 2 3 1 3 1 1 1 5 1 1 4 1 4 0 1 0 5 1
		 7 6 1 6 4 1 3 7 1 9 2 1 0 8 1 8 9 1 10 9 1 8 10 1 6 11 1 11 10 1 11 7 1;
	setAttr -s 8 -ch 36 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 5 7 8 -5 -3 9
		f 5 10 -1 -7 11 12
		f 3 13 -13 14
		f 6 -15 -12 -6 -9 15 16
		f 6 -17 17 -10 -2 -11 -14
		f 3 -18 -16 -8;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo31_physics" -p "breakingcrate_physics_grp6";
	rename -uid "27D1EC2F-4E77-BAC1-D406-54993FAE854A";
createNode mesh -n "breakingcrate_geo31_physicsShape" -p "breakingcrate_geo31_physics";
	rename -uid "BF5FF5A1-482D-8427-07C3-D7AB99D29341";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  32.11177444 60.24843597 31.25766373 37.097164154 44.73800659 31.25766373
		 32.11177444 44.73800659 -6.81515694 32.11177444 60.24843597 0.44142914 37.097164154 60.24843597 31.25766373
		 32.11177444 44.73800659 31.25766373 37.097164154 60.24843597 -3.70080853 37.097164154 44.73800659 -2.33979034
		 32.11177444 46.31562042 -8.9006443 37.097164154 50.6407814 -10.14282417;
	setAttr -s 15 ".ed[0:14]"  5 1 1 1 4 1 4 0 1 0 5 1 6 3 1 3 0 1 4 6 1
		 7 9 1 9 6 1 1 7 1 8 3 1 9 8 1 7 2 1 2 8 1 2 5 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -3 6
		f 5 7 8 -7 -2 9
		f 4 10 -5 -9 11
		f 4 -12 -8 12 13
		f 5 -14 14 -4 -6 -11
		f 4 -10 -1 -15 -13;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo32_physics" -p "breakingcrate_physics_grp6";
	rename -uid "414016F1-4D66-D3A0-AE90-0795D214D827";
createNode mesh -n "breakingcrate_geo32_physicsShape" -p "breakingcrate_geo32_physics";
	rename -uid "193A5CF1-4C47-1A24-D44C-57949903EC88";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  32.11177444 28.90206146 31.25766373 37.097164154 44.41249466 31.25765991
		 37.097164154 28.90206146 8.58999062 32.11177444 28.90206146 3.92869186 32.11177444 44.41249466 31.25765991
		 37.097164154 28.90206146 31.25766182 37.097164154 44.41249466 2.97935867 32.11177444 44.41249466 -1.68193817;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 3 1 3 0 1 0 4 1 5 1 1 1 4 1 0 5 1
		 6 2 1 2 3 1 7 6 1 1 6 1 5 2 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -4 6
		f 4 7 8 -2 9
		f 4 -10 -1 -6 10
		f 4 -11 -5 11 -8
		f 4 -7 -3 -9 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo33_physics" -p "breakingcrate_physics_grp6";
	rename -uid "11DE18CC-443B-885B-1BB7-14833DA16694";
createNode mesh -n "breakingcrate_geo33_physicsShape" -p "breakingcrate_geo33_physics";
	rename -uid "851FBA75-4CC1-B13B-57F3-BE85C160E658";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  35.76576996 30.69826889 23.60728455 39.89485168 16.80956268 23.60728455
		 35.76576996 16.80956268 23.60728455 35.76576996 16.80956268 2.12907505 39.89485168 30.69826889 23.60728455
		 39.89485168 30.69826889 1.15173054 39.89485168 16.80956268 5.66208887 35.76576996 30.69826889 -2.38128281;
	setAttr -s 12 ".ed[0:11]"  3 2 1 2 0 1 0 7 1 7 3 1 4 0 1 2 1 1 1 4 1
		 6 5 1 5 4 1 1 6 1 3 6 1 7 5 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -2 5 6
		f 4 7 8 -7 9
		f 4 -10 -6 -1 10
		f 4 -11 -4 11 -8
		f 4 -12 -3 -5 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo34_physics" -p "breakingcrate_physics_grp6";
	rename -uid "29ECBB98-4D48-EE48-8381-25AEAD5231B0";
createNode mesh -n "breakingcrate_geo34_physicsShape" -p "breakingcrate_geo34_physics";
	rename -uid "151353DE-410A-B3B1-C16E-D3831734FF99";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  32.11177444 7.20095301 31.25766373 37.097164154 22.71138763 31.25766373
		 37.097164154 7.20095348 -6.9481163 32.11177444 7.20095253 -9.5221405 32.11177444 22.71138573 31.25765991
		 37.097164154 7.20095253 31.25766373 37.097164154 22.71138382 -10.79120636 32.11177444 22.71138573 -13.36523056;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 3 1 3 0 1 0 4 1 5 1 1 1 4 1 0 5 1
		 6 2 1 2 3 1 7 6 1 1 6 1 5 2 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -4 6
		f 4 7 8 -2 9
		f 4 -10 -1 -6 10
		f 4 -11 -5 11 -8
		f 4 -7 -3 -9 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo35_physics" -p "breakingcrate_physics_grp6";
	rename -uid "A5B9748E-4104-EA14-5E41-5293B204EE2C";
createNode mesh -n "breakingcrate_geo35_physicsShape" -p "breakingcrate_geo35_physics";
	rename -uid "CEE14F01-498B-367C-6B3B-22BE7A5689C3";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  41.94765854 80.81236267 37.950634 37.81857681 81.054748535 24.064043045
		 41.94765854 5.99208069 22.75381851 41.94765854 81.054748535 24.064043045 37.81857681 80.81236267 37.950634
		 41.94765854 5.74968338 36.64040756 37.81857681 5.99208069 22.75381851 37.81857681 5.74968338 36.64040756;
	setAttr -s 12 ".ed[0:11]"  4 0 1 0 3 1 3 1 1 1 4 1 5 2 1 2 3 1 0 5 1
		 6 2 1 5 7 1 7 6 1 7 4 1 1 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 -5 8 9
		f 4 -10 10 -4 11
		f 4 -12 -3 -6 -8
		f 4 -7 -1 -11 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp7" -p "breakingcrate_physics";
	rename -uid "46B9A01A-46A5-643F-6342-FABEF7CA7D92";
	setAttr ".rp" -type "double3" 37.029716491699219 43.402212142944336 -13.782670021057129 ;
	setAttr ".sp" -type "double3" 37.029716491699219 43.402212142944336 -13.782670021057129 ;
createNode transform -n "breakingcrate_geo36_physics" -p "breakingcrate_physics_grp7";
	rename -uid "75F44D8A-4D1D-3C5C-269F-76B658B5184D";
createNode mesh -n "breakingcrate_geo36_physicsShape" -p "breakingcrate_geo36_physics";
	rename -uid "71C7268C-4F87-983C-73AF-4F92005B98D8";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 11 ".vt[0:10]"  32.11177444 63.21327209 -32.20341873 32.11177444 68.3217392 -8.84363842
		 37.097164154 63.21327209 -10.59526348 37.097164154 78.72370148 -13.39224625 32.11177444 78.72370148 -32.20341873
		 32.11177444 78.72370148 -11.127038 37.097164154 63.21327209 -32.20341873 32.11177444 63.21327209 -10.63098621
		 36.71852112 63.21327209 -10.12014484 36.38043594 64.084091187 -9.85295391 37.097164154 78.72370148 -32.20341873;
	setAttr -s 17 ".ed[0:16]"  5 3 1 3 10 1 10 4 1 4 5 1 6 0 1 0 4 1 10 6 1
		 3 2 1 2 6 1 8 7 1 7 0 1 2 8 1 9 8 1 3 9 1 5 1 1 1 9 1 1 7 1;
	setAttr -s 8 -ch 34 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -3 6
		f 4 -7 -2 7 8
		f 5 9 10 -5 -9 11
		f 4 12 -12 -8 13
		f 4 -14 -1 14 15
		f 4 -16 16 -10 -13
		f 5 -17 -15 -4 -6 -11;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo37_physics" -p "breakingcrate_physics_grp7";
	rename -uid "010913C8-43CF-4F0D-F4BE-AFBBD58FC365";
createNode mesh -n "breakingcrate_geo37_physicsShape" -p "breakingcrate_geo37_physics";
	rename -uid "4CCCC47A-4680-C485-DBEA-6A97617721BB";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  37.81857681 81.054740906 -36.64040756 41.94765854 5.99207687 -37.950634
		 41.94765854 80.81234741 -22.7538147 41.94765854 5.74968338 -24.06403923 37.81857681 80.81234741 -22.7538147
		 41.94765854 81.054740906 -36.64040756 37.81857681 5.99207687 -37.950634 37.81857681 5.74968338 -24.06403923;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 3 1 3 2 1 2 4 1 5 2 1 3 1 1 1 5 1
		 6 7 1 4 0 1 0 6 1 0 5 1 1 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -3 5 6
		f 4 7 -1 8 9
		f 4 -10 10 -7 11
		f 4 -12 -6 -2 -8
		f 4 -11 -9 -4 -5;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo38_physics" -p "breakingcrate_physics_grp7";
	rename -uid "705AC783-4D0B-6B9A-1F76-739DAEEA4462";
createNode mesh -n "breakingcrate_geo38_physicsShape" -p "breakingcrate_geo38_physics";
	rename -uid "E0C9B210-477A-6EE0-14A9-4C839617B86B";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 12 ".vt[0:11]"  35.76576996 59.33200455 -23.60728264 35.76576996 63.39143372 3.62067413
		 39.89485168 59.33200455 -1.13263321 39.89485168 73.22071075 -8.23316956 35.76576996 73.22071075 -23.60728455
		 39.89485168 59.33200455 -23.60728455 35.76576996 73.22071075 -8.039922714 35.76576996 59.33200455 1.13702297
		 39.89485168 61.68067169 0.30433464 35.78912354 63.39796448 3.61183262 39.89485168 73.18281555 -8.18821812
		 39.89485168 73.22071075 -23.60728645;
	setAttr -s 18 ".ed[0:17]"  5 0 1 0 4 1 4 11 1 11 5 1 6 3 1 3 11 1 4 6 1
		 7 1 1 1 6 1 0 7 1 9 1 1 7 2 1 2 8 1 8 9 1 10 9 1 8 10 1 2 5 1 3 10 1;
	setAttr -s 8 -ch 36 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -3 6
		f 5 7 8 -7 -2 9
		f 5 10 -8 11 12 13
		f 3 14 -14 15
		f 6 -16 -13 16 -4 -6 17
		f 5 -18 -5 -9 -11 -15
		f 4 -10 -1 -17 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo39_physics" -p "breakingcrate_physics_grp7";
	rename -uid "F526747C-45C9-9F99-1DE8-F9AC371A9052";
createNode mesh -n "breakingcrate_geo39_physicsShape" -p "breakingcrate_geo39_physics";
	rename -uid "B46C7E14-4355-71D5-E9E0-7BA3B4EEB859";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  32.11177444 60.24843597 2.68602371 37.097164154 44.73800659 -1.81065273
		 32.11177444 44.73800659 -6.81515598 37.097164154 44.73800659 -32.20341873 37.097164154 60.24843597 -32.20341873
		 32.11177444 44.73801041 -32.20341492 37.097164154 60.24843597 -3.17959118 32.11177444 60.24843597 -32.20341873;
	setAttr -s 13 ".ed[0:12]"  5 3 1 3 1 1 1 2 1 2 5 1 2 0 1 0 7 1 7 5 1
		 7 4 1 4 3 1 6 4 1 0 6 1 0 1 1 1 6 1;
	setAttr -s 7 -ch 26 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 -7 7 8 -1
		f 4 9 -8 -6 10
		f 3 -11 11 12
		f 4 -13 -2 -9 -10
		f 3 -3 -12 -5;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo40_physics" -p "breakingcrate_physics_grp7";
	rename -uid "3A3D26AD-4A44-EF1E-693F-0F9F7AA649F2";
createNode mesh -n "breakingcrate_geo40_physicsShape" -p "breakingcrate_geo40_physics";
	rename -uid "4725CD08-42AB-7967-6A92-83B818195654";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  37.097164154 28.90206146 10.38529396 32.11177444 28.90206146 -32.20341492
		 32.11177444 44.41249466 1.16493702 37.097164154 44.41249466 5.7247963 37.097164154 28.90206146 -32.20341492
		 32.11177444 44.41249466 -32.20341492 32.11177444 28.90206146 5.82543564 37.097164154 44.41249466 -32.20341873;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 3 1 3 0 1 0 4 1 5 2 1 2 3 1 7 5 1
		 6 2 1 5 1 1 1 6 1 1 4 1 0 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 -5 8 9
		f 4 -10 10 -4 11
		f 4 -12 -3 -6 -8
		f 4 -7 -1 -11 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo41_physics" -p "breakingcrate_physics_grp7";
	rename -uid "A817D5D9-401F-A9EB-8515-C682CD263126";
createNode mesh -n "breakingcrate_geo41_physicsShape" -p "breakingcrate_geo41_physics";
	rename -uid "7A68ADBF-454C-730C-48A8-65AD9F71D89B";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  39.89485168 30.69826889 -23.60728455 39.89485168 16.80956268 8.1814127
		 35.76576996 30.69826889 -0.49261189 39.89485168 30.69826889 3.031001091 39.89485168 16.80956268 -23.60728455
		 35.76576996 30.69826889 -23.60728455 35.76576996 16.80956268 4.65779877 35.76576996 16.80956268 -23.60728455;
	setAttr -s 12 ".ed[0:11]"  4 0 1 0 3 1 3 1 1 1 4 1 5 2 1 2 3 1 0 5 1
		 6 2 1 5 7 1 7 6 1 7 4 1 1 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 -5 8 9
		f 4 -10 10 -4 11
		f 4 -12 -3 -6 -8
		f 4 -7 -1 -11 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo42_physics" -p "breakingcrate_physics_grp7";
	rename -uid "B2B33955-4EBD-9DF7-64C2-19866B9B0E92";
createNode mesh -n "breakingcrate_geo42_physicsShape" -p "breakingcrate_geo42_physics";
	rename -uid "5B554AD0-4502-77E2-BA0B-4FAA8155885D";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  37.097164154 22.71138573 -32.20341873 37.097164154 7.20095348 -6.55305004
		 32.11177444 22.71138382 -12.77655983 37.097164154 22.71138382 -10.43059444 37.097164154 7.20095348 -32.20341873
		 32.11177444 22.71138382 -32.20341873 32.11177444 7.20095253 -8.89901447 32.11177444 7.20095253 -32.20341873;
	setAttr -s 12 ".ed[0:11]"  4 0 1 0 3 1 3 1 1 1 4 1 5 2 1 2 3 1 0 5 1
		 6 2 1 5 7 1 7 6 1 7 4 1 1 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 -5 8 9
		f 4 -10 10 -4 11
		f 4 -12 -3 -6 -8
		f 4 -7 -1 -11 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp8" -p "breakingcrate_physics";
	rename -uid "8C0052FF-4F5A-5F9D-6BC5-87AE8E493896";
	setAttr ".rp" -type "double3" 7.1549768447875977 43.402215957641602 -36.956401824951172 ;
	setAttr ".sp" -type "double3" 7.1549768447875977 43.402215957641602 -36.956401824951172 ;
createNode transform -n "breakingcrate_geo48_physics" -p "breakingcrate_physics_grp8";
	rename -uid "6313C638-4ADC-4AB3-4978-E2A6DDFC9C59";
createNode mesh -n "breakingcrate_geo48_physicsShape" -p "breakingcrate_geo48_physics";
	rename -uid "5E759534-4CCB-39D8-C425-949AFCED8D15";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  37.53705597 22.71138573 -37.53705215 37.53705215 7.20095539 -32.55166245
		 -9.46874809 22.71138573 -32.55166245 -7.00025367737 7.20095444 -32.55166245 37.53704834 7.20095539 -37.53705215
		 37.53705215 22.71138573 -32.55166245 -7.27898598 7.20095444 -37.53705215 -13.35692024 18.11436653 -32.55166245
		 -10.95358467 22.71138573 -37.53705215 -14.12751579 18.95882416 -37.53705215;
	setAttr -s 15 ".ed[0:14]"  5 1 1 1 4 1 4 0 1 0 5 1 6 4 1 1 3 1 3 6 1
		 7 3 1 5 2 1 2 7 1 8 2 1 0 8 1 6 9 1 9 8 1 9 7 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -2 5 6
		f 5 7 -6 -1 8 9
		f 4 10 -9 -4 11
		f 5 -12 -3 -5 12 13
		f 4 -14 14 -10 -11
		f 4 -15 -13 -7 -8;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo43_physics" -p "breakingcrate_physics_grp8";
	rename -uid "B254741C-406B-782F-7271-B786DCB60FCF";
createNode mesh -n "breakingcrate_geo43_physicsShape" -p "breakingcrate_geo43_physics";
	rename -uid "3F5B59E7-473D-7FB3-5557-22826489627C";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  37.53705597 78.72370148 -32.55166245 37.53705597 63.21327209 -37.53705215
		 37.53704834 63.21327209 -32.55166245 -5.12265873 63.21327209 -32.55166245 2.14857674 78.72370148 -32.55166245
		 37.53704834 78.72370148 -37.53705215 5.88399696 78.72370148 -37.53705215 -2.023539543 73.41616821 -32.55166245
		 -5.32409763 64.4654007 -37.53705215 -5.70443058 63.21327209 -37.53705215;
	setAttr -s 15 ".ed[0:14]"  5 0 1 0 2 1 2 1 1 1 5 1 6 4 1 4 0 1 5 6 1
		 7 3 1 3 2 1 4 7 1 8 7 1 6 8 1 1 9 1 9 8 1 9 3 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -1 6
		f 5 7 8 -2 -6 9
		f 4 10 -10 -5 11
		f 5 -12 -7 -4 12 13
		f 4 -14 14 -8 -11
		f 4 -15 -13 -3 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo44_physics" -p "breakingcrate_physics_grp8";
	rename -uid "7D5BDA0C-4AA3-2174-6B2F-96A7D152E3BE";
createNode mesh -n "breakingcrate_geo44_physicsShape" -p "breakingcrate_geo44_physics";
	rename -uid "2EE0A793-4AFE-DEF9-5AD7-CDB3AF96A54A";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  23.55450058 80.93927002 -37.81857681 23.55450058 5.8651619 -41.94765854
		 37.4432106 80.93927002 -41.94765854 37.4432106 80.93927002 -37.81857681 23.55450058 80.93927002 -41.94765854
		 23.55450058 5.8651619 -37.81857681 37.4432106 5.8651619 -41.94765854 37.4432106 5.8651619 -37.81857681;
	setAttr -s 12 ".ed[0:11]"  5 7 1 7 3 1 3 0 1 0 5 1 0 4 1 4 1 1 1 5 1
		 6 2 1 2 3 1 7 6 1 1 6 1 4 2 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 7 8 -2 9
		f 4 -10 -1 -7 10
		f 4 -11 -6 11 -8
		f 4 -5 -3 -9 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo45_physics" -p "breakingcrate_physics_grp8";
	rename -uid "A8545860-4CE9-F0AF-5997-8BAC7D4CF209";
createNode mesh -n "breakingcrate_geo45_physicsShape" -p "breakingcrate_geo45_physics";
	rename -uid "E95DB1D1-4193-0862-5A08-829897B98B3C";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  37.53705215 44.73800659 -36.95053482 37.53705597 60.24843597 -31.96514511
		 -10.36940193 60.24843597 -36.95053482 -8.17207909 44.73800659 -36.95053482 37.53704834 44.73800659 -31.96514511
		 37.53704834 60.24843597 -36.95053482 -7.27307892 44.73800659 -31.96514511 -18.78546524 60.24843597 -31.96514511
		 -10.99748421 47.91139221 -36.95053482 -18.90971565 57.80782318 -31.96514511;
	setAttr -s 15 ".ed[0:14]"  5 1 1 1 4 1 4 0 1 0 5 1 6 3 1 3 0 1 4 6 1
		 7 9 1 9 6 1 1 7 1 8 3 1 9 8 1 7 2 1 2 8 1 2 5 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -3 6
		f 5 7 8 -7 -2 9
		f 4 10 -5 -9 11
		f 4 -12 -8 12 13
		f 5 -14 14 -4 -6 -11
		f 4 -10 -1 -15 -13;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo46_physics" -p "breakingcrate_physics_grp8";
	rename -uid "25537EF4-4195-CDB0-7FC4-2F89F5EE8704";
createNode mesh -n "breakingcrate_geo46_physicsShape" -p "breakingcrate_geo46_physics";
	rename -uid "D930D3F3-40AB-7BE8-F1A1-91B710B517F5";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  37.53704834 44.41249466 -37.53705215 37.53705215 28.90205956 -32.55166245
		 37.53704834 44.41249847 -32.55166245 -5.49213791 44.41249847 -32.55166245 -1.20617867 28.90206146 -32.55166245
		 2.13294601 28.90205956 -37.53705215 37.53704834 28.90206146 -37.53705215 -5.89792633 44.41249466 -37.53705215;
	setAttr -s 13 ".ed[0:12]"  4 3 1 3 7 1 7 4 1 4 1 1 1 2 1 2 3 1 5 4 1
		 7 5 1 6 5 1 7 0 1 0 6 1 0 2 1 1 6 1;
	setAttr -s 7 -ch 26 ".fc[0:6]" -type "polyFaces" 
		f 3 0 1 2
		f 4 3 4 5 -1
		f 3 6 -3 7
		f 4 8 -8 9 10
		f 4 -11 11 -5 12
		f 4 -13 -4 -7 -9
		f 4 -6 -12 -10 -2;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo47_physics" -p "breakingcrate_physics_grp8";
	rename -uid "3D67C752-4A47-D7DE-7D5A-EC93C163ECD1";
createNode mesh -n "breakingcrate_geo47_physicsShape" -p "breakingcrate_geo47_physics";
	rename -uid "BA8E833E-47E6-7FD2-F257-6398A92A4915";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -23.10589981 30.90401459 -36.64554596 24.10687828 30.49199295 -40.77462387
		 23.98567772 16.60381889 -36.64554596 24.10687828 30.49199486 -36.64554596 -23.10590172 30.90401268 -40.77462387
		 -23.22710037 17.015838623 -36.64554596 23.98567581 16.60381889 -40.77462387 -23.22710228 17.015838623 -40.77462387;
	setAttr -s 12 ".ed[0:11]"  4 0 1 0 3 1 3 1 1 1 4 1 5 2 1 2 3 1 0 5 1
		 6 2 1 5 7 1 7 6 1 7 4 1 1 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 -5 8 9
		f 4 -10 10 -4 11
		f 4 -12 -3 -6 -8
		f 4 -7 -1 -11 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp9" -p "breakingcrate_physics";
	rename -uid "D3125D10-4B9B-4131-C03C-8A944824CBE9";
	setAttr ".rp" -type "double3" -17.773495197296143 25.081088066101074 -37.249660491943359 ;
	setAttr ".sp" -type "double3" -17.773495197296143 25.081088066101074 -37.249660491943359 ;
createNode transform -n "breakingcrate_geo49_physics" -p "breakingcrate_physics_grp9";
	rename -uid "0626A4DB-4AC8-76B1-7726-5FAF6F0EAE6B";
createNode mesh -n "breakingcrate_geo49_physicsShape" -p "breakingcrate_geo49_physics";
	rename -uid "B0C1E685-45FC-D707-168D-25903722BD9C";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 12 ".vt[0:11]"  -5.3172617 44.41249466 -32.55166245 2.25701809 28.90206146 -37.53705215
		 -37.53705597 28.90206146 -32.55166245 -37.53705215 44.41249466 -32.55166245 -5.89793015 44.41249466 -37.53705215
		 -37.53705215 44.41249466 -37.53705215 -1.1790123 28.90206337 -32.55166245 -2.27440548 41.63674545 -37.53705215
		 -1.56743813 36.65459824 -32.55166245 2.069215775 32.65035248 -37.53705215 -4.70137119 44.41249466 -34.35655594
		 -37.53705597 28.90206337 -37.53705215;
	setAttr -s 18 ".ed[0:17]"  5 11 1 11 2 1 2 3 1 3 5 1 6 2 1 11 1 1 1 6 1
		 8 0 1 0 3 1 6 8 1 9 8 1 1 9 1 10 7 1 7 4 1 4 10 1 4 5 1 0 10 1 9 7 1;
	setAttr -s 8 -ch 36 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -2 5 6
		f 5 7 8 -3 -5 9
		f 4 10 -10 -7 11
		f 3 12 13 14
		f 5 -15 15 -4 -9 16
		f 5 -17 -8 -11 17 -13
		f 6 -12 -6 -1 -16 -14 -18;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo50_physics" -p "breakingcrate_physics_grp9";
	rename -uid "10BDA57B-4E5D-EA41-39E4-33BDA3941DBF";
createNode mesh -n "breakingcrate_geo50_physicsShape" -p "breakingcrate_geo50_physics";
	rename -uid "921065C2-45A5-1249-F22A-AFB829BC8E01";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -5.71278954 7.20095348 -37.36133957 -37.53704834 22.71138573 -32.55166245
		 -10.13558006 22.71138573 -37.53705215 -9.4352684 22.71138763 -32.55166245 -37.53704834 7.20095253 -32.55166245
		 -37.53704834 22.71138573 -37.53705215 -6.83757782 7.20095205 -32.55166245 -8.48067093 19.34489059 -32.55166245
		 -5.73747349 7.20095396 -37.53705215 -37.53705597 7.20095158 -37.53705215;
	setAttr -s 15 ".ed[0:14]"  5 9 1 9 4 1 4 1 1 1 5 1 1 3 1 3 2 1 2 5 1
		 7 6 1 6 0 1 0 7 1 8 2 1 3 7 1 0 8 1 6 4 1 9 8 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 3 7 8 9
		f 5 10 -6 11 -10 12
		f 5 -13 -9 13 -2 14
		f 4 -15 -1 -7 -11
		f 5 -12 -5 -3 -14 -8;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo51_physics" -p "breakingcrate_physics_grp9";
	rename -uid "C0FBC5AE-4322-2A17-0602-DFB8BA5CBC05";
createNode mesh -n "breakingcrate_geo51_physicsShape" -p "breakingcrate_geo51_physics";
	rename -uid "5FD615DC-4345-B3C2-1A5D-0C8FD3399EBE";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -37.26660156 36.77983093 -41.94765854 -23.24570084 44.23182678 -37.81857681
		 -37.80400848 5.99207306 -37.81857681 -23.9174118 5.74968338 -41.94765854 -37.80400467 5.99207687 -41.94765854
		 -37.28393555 35.78672791 -37.81857681 -23.32888222 39.46653748 -41.94765854 -23.9174118 5.74968147 -37.81857681;
	setAttr -s 13 ".ed[0:12]"  4 3 1 3 7 1 7 2 1 2 4 1 5 2 1 7 1 1 1 5 1
		 1 0 1 0 5 1 6 3 1 4 0 1 0 6 1 1 6 1;
	setAttr -s 7 -ch 26 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -3 5 6
		f 3 -7 7 8
		f 4 9 -1 10 11
		f 3 -12 -8 12
		f 4 -13 -6 -2 -10
		f 4 -9 -11 -4 -5;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp10" -p "breakingcrate_physics";
	rename -uid "3CC2B3FA-41DA-163B-DE61-829967E0DC0F";
	setAttr ".rp" -type "double3" -6.5793991088867188 58.118282318115234 -36.956401824951172 ;
	setAttr ".sp" -type "double3" -6.5793991088867188 58.118282318115234 -36.956401824951172 ;
createNode transform -n "breakingcrate_geo52_physics" -p "breakingcrate_physics_grp10";
	rename -uid "71649448-43CE-F66F-BF99-D98E7EB045A5";
createNode mesh -n "breakingcrate_geo52_physicsShape" -p "breakingcrate_geo52_physics";
	rename -uid "C21B26A0-4AA4-7F7C-B8C9-48B7909E0191";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 12 ".vt[0:11]"  -36.49378204 81.054748535 -37.81857681 -22.60718727 80.81235504 -41.94765854
		 -23.24570274 44.23181152 -37.81857681 -37.28393936 35.78672791 -37.81857681 -36.49377823 81.054733276 -41.94765854
		 -22.60718918 80.81234741 -37.81857681 -23.33252144 39.25799179 -41.94765854 -37.26660156 36.77983475 -41.94765854
		 -24.07869339 41.95102692 -37.81857681 -36.29191589 35.53024292 -37.81857681 -23.28634644 41.90340042 -38.43979263
		 -31.085964203 35.1818161 -41.94765854;
	setAttr -s 18 ".ed[0:17]"  5 1 1 1 4 1 4 0 1 0 5 1 7 4 1 1 6 1 6 11 1
		 11 7 1 9 8 1 8 2 1 2 5 1 0 3 1 3 9 1 3 7 1 11 9 1 10 8 1 6 10 1 2 10 1;
	setAttr -s 8 -ch 36 ".fc[0:7]" -type "polyFaces" 
		f 4 0 1 2 3
		f 5 4 -2 5 6 7
		f 6 8 9 10 -4 11 12
		f 4 -13 13 -8 14
		f 5 15 -9 -15 -7 16
		f 5 -17 -6 -1 -11 17
		f 3 -18 -10 -16
		f 4 -14 -12 -3 -5;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo53_physics" -p "breakingcrate_physics_grp10";
	rename -uid "6D786B90-4B3A-F596-AABC-81B30B5B5C94";
createNode mesh -n "breakingcrate_geo53_physicsShape" -p "breakingcrate_geo53_physics";
	rename -uid "4355402A-42F7-486E-BB4A-FA965B8A22FC";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 12 ".vt[0:11]"  -37.53705215 60.24843597 -36.95053482 -5.33204269 44.73801041 -34.73387527
		 -18.78546715 60.24843597 -31.96514511 -10.17542648 60.24843597 -36.95053482 -37.53705597 44.73800659 -36.95053482
		 -37.53705597 60.24843979 -31.96514511 -7.15807056 44.73800659 -31.96514511 -6.27325058 44.73800659 -36.95053482
		 -12.42551994 57.69540024 -31.96514511 -12.14645958 60.24843597 -33.96194077 -8.59352112 56.35710907 -36.95053482
		 -37.53705597 44.73800659 -31.96514511;
	setAttr -s 18 ".ed[0:17]"  7 1 1 1 6 1 6 11 1 11 4 1 4 7 1 8 2 1 2 5 1
		 5 11 1 6 8 1 9 3 1 3 0 1 0 5 1 2 9 1 8 9 1 10 7 1 4 0 1 3 10 1 1 10 1;
	setAttr -s 8 -ch 36 ".fc[0:7]" -type "polyFaces" 
		f 5 0 1 2 3 4
		f 5 5 6 7 -3 8
		f 5 9 10 11 -7 12
		f 3 -13 -6 13
		f 5 14 -5 15 -11 16
		f 6 -17 -10 -14 -9 -2 17
		f 3 -18 -1 -15
		f 4 -12 -16 -4 -8;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo54_physics" -p "breakingcrate_physics_grp10";
	rename -uid "0D10BB25-49DA-E11D-FABD-BDA4D6A855EE";
createNode mesh -n "breakingcrate_geo54_physicsShape" -p "breakingcrate_geo54_physics";
	rename -uid "6E80820A-49F5-D6EB-0ECA-359A4EDDAAAA";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -22.77160835 58.10601425 -40.77462387 24.37825775 60.577034 -36.64554596
		 23.65137482 74.44670105 -40.77462387 23.65137863 74.44670105 -36.64554596 24.37825584 60.577034 -40.77462387
		 -22.77160645 58.10601425 -36.64554596 -23.49848366 71.97568512 -40.77462387 -23.49848557 71.97568512 -36.64554596;
	setAttr -s 12 ".ed[0:11]"  4 2 1 2 3 1 3 1 1 1 4 1 5 0 1 0 4 1 1 5 1
		 6 2 1 0 6 1 5 7 1 7 6 1 7 3 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -4 6
		f 4 7 -1 -6 8
		f 4 -9 -5 9 10
		f 4 -11 11 -2 -8
		f 4 -7 -3 -12 -10;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo55_physics" -p "breakingcrate_physics_grp10";
	rename -uid "D5D85F65-486F-7007-C65D-6CB8E18E2EFF";
createNode mesh -n "breakingcrate_geo55_physicsShape" -p "breakingcrate_geo55_physics";
	rename -uid "D8A15B59-4ABA-10DA-EDB4-5B9F0ABF8EC5";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -37.53705215 78.72370148 -32.55166245 6.49892712 78.72370148 -37.53705215
		 -4.13885498 63.21327209 -32.55166245 -37.53704834 78.72370148 -37.53705215 -37.53705597 63.21327209 -32.55166245
		 -4.59409142 63.21327209 -37.53705215 2.38809872 78.72370148 -32.55166245 4.81153774 74.18243408 -37.53705215
		 -2.79101849 64.78516388 -32.55166245 -37.53705597 63.21327209 -37.53705215;
	setAttr -s 15 ".ed[0:14]"  5 2 1 2 4 1 4 9 1 9 5 1 6 1 1 1 3 1 3 0 1
		 0 6 1 7 5 1 9 3 1 1 7 1 8 7 1 6 8 1 0 4 1 2 8 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 6 7
		f 5 8 -4 9 -6 10
		f 4 11 -11 -5 12
		f 5 -13 -8 13 -2 14
		f 4 -15 -1 -9 -12
		f 4 -14 -7 -10 -3;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp11" -p "breakingcrate_physics";
	rename -uid "B4E4F9AD-4191-2AB9-3B9E-8F82DEB6BE1D";
	setAttr ".rp" -type "double3" -8.6867132186889648 82.209758758544922 -0.001434326171875 ;
	setAttr ".sp" -type "double3" -8.6867132186889648 82.209758758544922 -0.001434326171875 ;
createNode transform -n "breakingcrate_geo56_physics" -p "breakingcrate_physics_grp11";
	rename -uid "2ABF297D-4B9F-05F5-31D5-E799165B3241";
createNode mesh -n "breakingcrate_geo56_physicsShape" -p "breakingcrate_geo56_physics";
	rename -uid "18E4BFEA-4429-A951-DC9F-B39B40025A33";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -36.5575676 82.24280548 -22.14099503 19.18414879 80.19548035 -37.39042282
		 4.92319107 78.75595856 -22.14099503 -36.5575676 82.24280548 -37.39042282 -36.5575676 78.75595856 -22.14099503
		 3.78783321 82.24280548 -22.14099503 18.51751328 82.24280548 -37.39042282 19.0016479492 78.75595856 -37.39041901
		 12.4766655 78.75595856 -29.96099854 -36.55757141 78.75595856 -37.39042282;
	setAttr -s 15 ".ed[0:14]"  4 0 1 0 3 1 3 9 1 9 4 1 5 0 1 4 2 1 2 5 1
		 7 9 1 3 6 1 6 1 1 1 7 1 8 7 1 1 8 1 6 5 1 2 8 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -1 5 6
		f 5 7 -3 8 9 10
		f 3 11 -11 12
		f 5 -13 -10 13 -7 14
		f 5 -15 -6 -4 -8 -12
		f 4 -9 -2 -5 -14;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo57_physics" -p "breakingcrate_physics_grp11";
	rename -uid "47FEFA39-45DC-833F-2D8D-F4B8861A3F93";
createNode mesh -n "breakingcrate_geo57_physicsShape" -p "breakingcrate_geo57_physics";
	rename -uid "E34C2AE8-4F12-2270-357F-C5B4178ADAFB";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -35.91174316 78.75595856 -7.55889416 8.85404778 82.24280548 -12.67596054
		 2.48314381 78.75595856 -21.16147041 5.66617203 78.75595856 -7.92173862 -35.91174316 82.24280548 -7.55889463
		 -36.027519226 78.75595856 -20.82539368 4.045113564 82.24280548 -21.17509842 1.14743614 82.24280548 -7.88230419
		 8.85283661 78.75595856 -9.90390205 -36.027526855 82.24280548 -20.82539368;
	setAttr -s 15 ".ed[0:14]"  6 2 1 2 5 1 5 9 1 9 6 1 7 4 1 4 0 1 0 3 1
		 3 7 1 7 1 1 1 6 1 9 4 1 8 3 1 0 5 1 2 8 1 1 8 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 6 7
		f 5 8 9 -4 10 -5
		f 5 11 -7 12 -2 13
		f 4 -14 -1 -10 14
		f 4 -15 -9 -8 -12
		f 4 -13 -6 -11 -3;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo58_physics" -p "breakingcrate_physics_grp11";
	rename -uid "440E7F61-45FF-4D66-E3DC-B08C761BD6F0";
createNode mesh -n "breakingcrate_geo58_physicsShape" -p "breakingcrate_geo58_physics";
	rename -uid "622E7F77-49FB-1F06-3458-B38AC7CB4DF5";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  2.70578384 82.24280548 -6.73320961 -36.55757141 78.75595856 -6.73320913
		 -1.53275108 78.75595856 4.093885422 0.47266197 82.24280548 4.093883514 -36.55757141 82.24280548 -6.73320913
		 -36.55757141 78.75595856 4.093883991 0.70037079 78.75595856 -6.73320913 -36.55757141 82.24280548 4.093883991;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 3 1 3 0 1 0 4 1 5 2 1 2 3 1 7 5 1
		 6 2 1 5 1 1 1 6 1 1 4 1 0 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 -5 8 9
		f 4 -10 10 -4 11
		f 4 -12 -3 -6 -8
		f 4 -7 -1 -11 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo59_physics" -p "breakingcrate_physics_grp11";
	rename -uid "E9B1FF29-49E6-4E05-EF45-4B9C994A970D";
createNode mesh -n "breakingcrate_geo59_physicsShape" -p "breakingcrate_geo59_physics";
	rename -uid "F59B355A-4260-1709-E950-78B815B57C25";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -34.87895584 79.13249969 4.094445705 16.87081909 80.43444824 5.50769567
		 -34.87895203 82.61602783 4.24654055 -35.34009552 78.36435699 21.68771553 -5.084574699 78.55345154 17.35674667
		 14.64040089 82.55947113 5.54201555 -12.23902321 81.96373749 19.18656731 16.060932159 79.022102356 6.62284756
		 12.29287052 79.078613281 5.32850695 -35.35729218 81.81925201 22.49586487;
	setAttr -s 15 ".ed[0:14]"  3 9 1 9 2 1 2 0 1 0 3 1 6 5 1 5 2 1 9 6 1
		 3 4 1 4 6 1 8 7 1 7 4 1 0 8 1 5 1 1 1 8 1 1 7 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 -7 -1 7 8
		f 5 9 10 -8 -4 11
		f 5 -12 -3 -6 12 13
		f 3 -14 14 -10
		f 5 -15 -13 -5 -9 -11;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo60_physics" -p "breakingcrate_physics_grp11";
	rename -uid "14B3B8A8-47FF-BD7C-7D5E-7E86A39A4DF9";
createNode mesh -n "breakingcrate_geo60_physicsShape" -p "breakingcrate_geo60_physics";
	rename -uid "C921AE82-46C0-87D4-4CDC-589C60571FD7";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -2.16223145 82.24280548 25.018505096 -36.55757141 78.75595856 21.52891922
		 -4.50601006 78.75595856 36.80390549 -36.55757141 82.24280548 21.53614807 -36.55757141 78.75595856 36.80390549
		 -9.86191654 78.75595856 21.5471344 -11.36746311 82.24280548 36.80390549 -7.0048666 82.24280548 21.55631638
		 -4.32910728 78.75595856 25.50275612 -36.55757523 82.24280548 36.80390549;
	setAttr -s 16 ".ed[0:15]"  6 2 1 2 0 1 0 6 1 6 9 1 9 4 1 4 2 1 7 5 1
		 5 1 1 1 3 1 3 7 1 3 9 1 0 7 1 8 5 1 0 8 1 2 8 1 4 1 1;
	setAttr -s 8 -ch 32 ".fc[0:7]" -type "polyFaces" 
		f 3 0 1 2
		f 4 3 4 5 -1
		f 4 6 7 8 9
		f 5 -10 10 -4 -3 11
		f 4 12 -7 -12 13
		f 3 -14 -2 14
		f 5 -15 -6 15 -8 -13
		f 4 -5 -11 -9 -16;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo61_physics" -p "breakingcrate_physics_grp11";
	rename -uid "E874D159-4279-D1D0-FA82-EBB9ADAB199D";
createNode mesh -n "breakingcrate_geo61_physicsShape" -p "breakingcrate_geo61_physics";
	rename -uid "F670D7DA-4836-CF3B-B312-3AAAB480EC8F";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -32.27711487 86.055160522 37.38755417 -17.036973953 82.5683136 36.85535812
		 -34.8697319 82.5683136 -36.85536194 -17.036973953 86.055160522 36.85535812 -34.8697319 86.055160522 -36.85536194
		 -19.6295948 82.5683136 -37.3875618 -32.27711487 82.5683136 37.38755417 -19.6295948 86.055160522 -37.3875618;
	setAttr -s 12 ".ed[0:11]"  5 2 1 2 4 1 4 7 1 7 5 1 7 3 1 3 1 1 1 5 1
		 6 2 1 1 6 1 3 0 1 0 6 1 0 4 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 7 -1 -7 8
		f 4 -9 -6 9 10
		f 4 -11 11 -2 -8
		f 4 -12 -10 -5 -3;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp12" -p "breakingcrate_physics";
	rename -uid "A3E71D0B-4061-EF13-E5D2-51A2EB0626E4";
	setAttr ".rp" -type "double3" -36.44320011138916 43.402212142944336 -13.401755332946777 ;
	setAttr ".sp" -type "double3" -36.44320011138916 43.402212142944336 -13.401755332946777 ;
createNode transform -n "breakingcrate_geo62_physics" -p "breakingcrate_physics_grp12";
	rename -uid "8B7102C6-46F0-BBFE-709D-FAAE3522258F";
createNode mesh -n "breakingcrate_geo62_physicsShape" -p "breakingcrate_geo62_physics";
	rename -uid "F3420FE9-4538-AAAD-7DF0-67A86305EBA4";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -37.097164154 63.21327209 -32.15869522 -32.11177444 78.72370148 11.14712334
		 -32.11177444 63.21327209 1.64274311 -37.097164154 70.63397217 5.33481216 -37.097164154 78.72370148 -32.15869522
		 -32.11177444 63.21327209 -32.15869904 -37.097164154 78.72370148 10.29198647 -37.097164154 63.21327209 -3.45586491
		 -33.2118454 63.21327209 1.45404816 -32.11177444 78.72370148 -32.15869904;
	setAttr -s 15 ".ed[0:14]"  5 0 1 0 4 1 4 9 1 9 5 1 6 1 1 1 9 1 4 6 1
		 7 3 1 3 6 1 0 7 1 8 7 1 5 2 1 2 8 1 2 1 1 3 8 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -3 6
		f 5 7 8 -7 -2 9
		f 5 10 -10 -1 11 12
		f 5 -13 13 -5 -9 14
		f 3 -15 -8 -11
		f 4 -4 -6 -14 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo63_physics" -p "breakingcrate_physics_grp12";
	rename -uid "996A3C62-4C08-81F3-A3B9-29B2ADD9A691";
createNode mesh -n "breakingcrate_geo63_physicsShape" -p "breakingcrate_geo63_physics";
	rename -uid "D080F04E-4BA0-0B8F-B372-B5A067DB8521";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -40.33473969 58.92106628 -23.48249435 -38.31944656 73.089126587 -7.59883881
		 -36.20565796 59.046905518 -16.27334785 -40.33473969 72.80764771 -23.72488403 -36.20565796 58.9210701 -23.48249435
		 -40.33473969 59.046920776 -16.27242088 -36.20565796 73.088905334 -7.61144924 -40.33473969 73.039665222 -10.43267536
		 -40.3179512 59.047332764 -16.24881172 -36.20565796 72.80764771 -23.72488403;
	setAttr -s 15 ".ed[0:14]"  4 0 1 0 3 1 3 9 1 9 4 1 6 2 1 2 4 1 9 6 1
		 7 1 1 1 6 1 3 7 1 8 5 1 5 0 1 2 8 1 1 8 1 7 5 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -4 6
		f 5 7 8 -7 -3 9
		f 5 10 11 -1 -6 12
		f 4 -13 -5 -9 13
		f 4 -14 -8 14 -11
		f 4 -10 -2 -12 -15;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo64_physics" -p "breakingcrate_physics_grp12";
	rename -uid "E54D6821-4406-AE3A-3C65-CAB5D39BAC82";
createNode mesh -n "breakingcrate_geo64_physicsShape" -p "breakingcrate_geo64_physics";
	rename -uid "25E35D13-4AE8-8614-C663-87B79B150C92";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -32.11177444 44.73800659 5.064087868 -37.097164154 44.73800659 -32.15869904
		 -37.097164154 60.24843597 -2.2151022 -32.11177444 60.24843597 -1.27577686 -32.11177444 44.73800659 -32.15869904
		 -37.097164154 60.24843597 -32.15869904 -37.097164154 44.73800659 4.12476826 -32.11177444 60.24843597 -32.15869904;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 3 1 3 0 1 0 4 1 5 2 1 2 3 1 7 5 1
		 6 2 1 5 1 1 1 6 1 1 4 1 0 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 -5 8 9
		f 4 -10 10 -4 11
		f 4 -12 -3 -6 -8
		f 4 -7 -1 -11 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo65_physics" -p "breakingcrate_physics_grp12";
	rename -uid "D7311C4D-49D2-5206-4789-E093D26DEAC1";
createNode mesh -n "breakingcrate_geo65_physicsShape" -p "breakingcrate_geo65_physics";
	rename -uid "F68C3595-4630-70E2-5C93-51B615511340";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -30.93874168 28.90206146 9.88806534 -35.9241333 28.90205956 -32.15870285
		 -35.9241333 44.41249466 2.58218861 -30.93874168 44.41249466 3.62856674 -30.93874168 28.90206146 -32.15869904
		 -35.9241333 44.41249466 -32.15870285 -35.9241333 28.90205956 8.84169006 -30.93874168 44.41249466 -32.15870285;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 3 1 3 0 1 0 4 1 5 2 1 2 3 1 7 5 1
		 6 2 1 5 1 1 1 6 1 1 4 1 0 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 -5 8 9
		f 4 -10 10 -4 11
		f 4 -12 -3 -6 -8
		f 4 -7 -1 -11 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo66_physics" -p "breakingcrate_physics_grp12";
	rename -uid "245123B3-4F28-E2DE-5D5E-3DB62D776BBE";
createNode mesh -n "breakingcrate_geo66_physicsShape" -p "breakingcrate_geo66_physics";
	rename -uid "3CBB8784-4A1A-14C0-D4CC-A1940CAB0E75";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -40.33473969 30.77568436 -2.095731735 -40.33473969 31.51791763 -23.3505497
		 -36.20565796 31.51792145 -23.35055161 -36.20565796 30.79092789 -2.5322752 -36.20565796 17.22862816 -12.12163448
		 -40.33473969 17.63767624 -23.83526039 -40.33473969 17.21338463 -11.68509293 -36.20565796 17.63767624 -23.8352623;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 2 1 2 3 1 3 4 1 5 1 1 1 2 1 7 5 1
		 6 5 1 4 6 1 3 0 1 0 6 1 0 1 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 -7 -1 8
		f 4 -9 -4 9 10
		f 4 -11 11 -5 -8
		f 4 -3 -6 -12 -10;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo67_physics" -p "breakingcrate_physics_grp12";
	rename -uid "A023212D-41EA-8F26-99F7-49B5F464CE8D";
createNode mesh -n "breakingcrate_geo67_physicsShape" -p "breakingcrate_geo67_physics";
	rename -uid "39B513D6-499F-B2E3-03E8-08AB8E6BE2E0";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -32.11177444 22.71138573 -3.22383022 -37.097164154 7.20095158 -32.15869904
		 -37.097164154 22.71138573 -7.47247505 -37.097164154 7.20095301 -10.41352367 -32.11177444 7.20095396 -10.055336952
		 -37.097164154 22.71138763 -32.15869904 -32.11177444 7.20095301 -32.15869904 -32.11177444 16.062177658 -3.37230492
		 -37.097164154 10.74631691 -7.73965168 -32.11177444 22.71138763 -32.15869904;
	setAttr -s 15 ".ed[0:14]"  5 2 1 2 0 1 0 9 1 9 5 1 6 4 1 4 3 1 3 1 1
		 1 6 1 7 4 1 6 9 1 0 7 1 8 7 1 2 8 1 5 1 1 3 8 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 6 7
		f 5 8 -5 9 -3 10
		f 4 11 -11 -2 12
		f 5 -13 -1 13 -7 14
		f 4 -15 -6 -9 -12
		f 4 -8 -14 -4 -10;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo68_physics" -p "breakingcrate_physics_grp12";
	rename -uid "A4FA86AD-4973-E9C6-5BE3-13B540B30FDA";
createNode mesh -n "breakingcrate_geo68_physicsShape" -p "breakingcrate_geo68_physics";
	rename -uid "E1210F38-41D3-C3BC-6F71-28B47EEBF8C3";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -41.94765854 81.054740906 -36.64040756 -37.81857681 5.99207687 -37.950634
		 -37.81857681 80.81234741 -22.7538147 -37.81857681 5.74968338 -24.06403923 -41.94765854 80.81234741 -22.7538147
		 -37.81857681 81.054740906 -36.64040756 -41.94765854 5.99207687 -37.950634 -41.94765854 5.74968338 -24.06403923;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 3 1 3 2 1 2 4 1 5 2 1 3 1 1 1 5 1
		 6 7 1 4 0 1 0 6 1 0 5 1 1 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -3 5 6
		f 4 7 -1 8 9
		f 4 -10 10 -7 11
		f 4 -12 -6 -2 -8
		f 4 -11 -9 -4 -5;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_physics_grp13" -p "breakingcrate_physics";
	rename -uid "0A79E807-4E9F-C859-7994-D9B1EBE44037";
	setAttr ".rp" -type "double3" -36.44320011138916 43.402206420898437 9.6520414352416992 ;
	setAttr ".sp" -type "double3" -36.44320011138916 43.402206420898437 9.6520414352416992 ;
createNode transform -n "breakingcrate_geo69_physics" -p "breakingcrate_physics_grp13";
	rename -uid "208161E1-4FC4-6B42-C45A-98801CFC204A";
createNode mesh -n "breakingcrate_geo69_physicsShape" -p "breakingcrate_geo69_physics";
	rename -uid "BEF928D9-4473-30DB-D282-0F9837B3A6E4";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -37.097164154 63.21327209 31.27891922 -32.11177444 78.72370148 31.27892303
		 -32.11177444 63.21327209 31.27891922 -37.097164154 78.72370148 31.27891922 -37.097164154 78.72370148 7.07053566
		 -32.11177444 63.21327209 -2.089233398 -32.11177444 78.72370148 8.4371624 -37.097164154 63.21327209 -3.45586395;
	setAttr -s 12 ".ed[0:11]"  3 0 1 0 2 1 2 1 1 1 3 1 5 2 1 0 7 1 7 5 1
		 6 5 1 7 4 1 4 6 1 4 3 1 1 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -2 5 6
		f 4 7 -7 8 9
		f 4 -10 10 -4 11
		f 4 -12 -3 -5 -8
		f 4 -9 -6 -1 -11;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo70_physics" -p "breakingcrate_physics_grp13";
	rename -uid "54682482-4D11-1607-C670-8BA180F87723";
createNode mesh -n "breakingcrate_geo70_physicsShape" -p "breakingcrate_geo70_physics";
	rename -uid "24483F26-42B3-07E0-DD56-C587C71CE29E";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -36.20565796 59.74506378 23.72489166 -40.33473969 73.63165283 23.48249817
		 -36.20565796 73.085174561 -7.82547665 -36.20565796 59.033325195 -17.051059723 -40.33473969 59.74506378 23.72488976
		 -36.20565796 73.63165283 23.48249626 -40.33473969 73.023025513 -11.38605499 -40.33473969 59.04126358 -16.59600639
		 -36.20565796 63.018146515 -18.22605896 -40.33473969 65.99537659 -18.64655113;
	setAttr -s 15 ".ed[0:14]"  5 1 1 1 4 1 4 0 1 0 5 1 6 1 1 5 2 1 2 6 1
		 7 4 1 6 9 1 9 7 1 8 3 1 3 7 1 9 8 1 2 8 1 0 3 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -1 5 6
		f 5 7 -2 -5 8 9
		f 4 10 11 -10 12
		f 4 -13 -9 -7 13
		f 5 -14 -6 -4 14 -11
		f 4 -12 -15 -3 -8;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo71_physics" -p "breakingcrate_physics_grp13";
	rename -uid "EB5781E5-4DF9-9A5F-B0C1-E594CA273918";
createNode mesh -n "breakingcrate_geo71_physicsShape" -p "breakingcrate_geo71_physics";
	rename -uid "059B09E6-456D-9B63-D87D-D78DAAAE52CE";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -37.81857681 81.054733276 36.64040756 -41.94765854 5.99207306 37.950634
		 -41.94765854 80.81234741 22.75381851 -41.94765854 5.74967957 24.064041138 -37.81857681 5.99207306 37.950634
		 -41.94765854 81.054733276 36.64040756 -37.81857681 80.81234741 22.75381851 -37.81857681 5.74967957 24.064041138;
	setAttr -s 12 ".ed[0:11]"  5 2 1 2 3 1 3 1 1 1 5 1 1 4 1 4 0 1 0 5 1
		 6 2 1 0 6 1 4 7 1 7 6 1 7 3 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 7 -1 -7 8
		f 4 -9 -6 9 10
		f 4 -11 11 -2 -8
		f 4 -5 -3 -12 -10;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo72_physics" -p "breakingcrate_physics_grp13";
	rename -uid "0F63D019-4183-7F55-1D61-A7BF8DC0377D";
createNode mesh -n "breakingcrate_geo72_physicsShape" -p "breakingcrate_geo72_physics";
	rename -uid "CDAC0E31-426C-31A8-DD2E-518D0A755DBA";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -37.097164154 44.73800659 31.27892113 -32.11177444 60.24843597 31.27892494
		 -32.11177444 44.73800659 4.756567 -37.097164154 60.24843597 31.27892303 -32.11177444 60.24843597 -1.7620163
		 -37.097164154 44.73800659 4.013557434 -32.11177444 44.73800659 31.27892303 -37.097164154 60.24843597 -2.50502396;
	setAttr -s 12 ".ed[0:11]"  4 7 1 7 3 1 3 1 1 1 4 1 5 0 1 0 3 1 7 5 1
		 6 2 1 2 4 1 1 6 1 0 6 1 5 2 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -2 6
		f 4 7 8 -4 9
		f 4 -10 -3 -6 10
		f 4 -11 -5 11 -8
		f 4 -7 -1 -9 -12;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo73_physics" -p "breakingcrate_physics_grp13";
	rename -uid "ABE92739-4975-2BBC-8320-FA804C34B167";
createNode mesh -n "breakingcrate_geo73_physicsShape" -p "breakingcrate_geo73_physics";
	rename -uid "E964F237-4339-6294-F1CE-CFA6EA4121A7";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -35.9241333 28.90206146 31.27892303 -30.93874168 44.41249466 31.27892494
		 -30.93874168 28.90206146 9.45143509 -35.9241333 44.41249466 31.27892303 -35.9241333 28.90206146 8.64818764
		 -30.93874168 44.41249466 3.02269268 -30.93874168 28.90206146 31.27892303 -35.9241333 44.41249466 2.21944237;
	setAttr -s 12 ".ed[0:11]"  5 2 1 2 4 1 4 7 1 7 5 1 7 3 1 3 1 1 1 5 1
		 6 2 1 1 6 1 3 0 1 0 6 1 0 4 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 -4 4 5 6
		f 4 7 -1 -7 8
		f 4 -9 -6 9 10
		f 4 -11 11 -2 -8
		f 4 -12 -10 -5 -3;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo74_physics" -p "breakingcrate_physics_grp13";
	rename -uid "AA5EEE0E-430E-4ABF-FB96-B182F76FC017";
createNode mesh -n "breakingcrate_geo74_physicsShape" -p "breakingcrate_geo74_physics";
	rename -uid "69967B83-4929-4CC0-DD1C-7AA44CA0B416";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 8 ".vt[0:7]"  -36.20565796 32.55371094 23.92897415 -40.33473969 15.98991203 23.35055161
		 -40.33473969 30.14477158 -11.79021931 -36.20565796 15.98991203 23.35055161 -40.33473969 32.46916962 23.92601776
		 -36.20565796 30.21319962 -12.034905434 -40.33473969 17.23423004 -12.28207111 -36.20565796 17.24285507 -12.52903843;
	setAttr -s 12 ".ed[0:11]"  4 1 1 1 3 1 3 0 1 0 4 1 5 2 1 2 4 1 0 5 1
		 6 2 1 5 7 1 7 6 1 7 3 1 1 6 1;
	setAttr -s 6 -ch 24 ".fc[0:5]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 5 -4 6
		f 4 7 -5 8 9
		f 4 -10 10 -2 11
		f 4 -12 -1 -6 -8
		f 4 -7 -3 -11 -9;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode transform -n "breakingcrate_geo75_physics" -p "breakingcrate_physics_grp13";
	rename -uid "4A3AFE95-4521-B433-0EBD-37AE2DE3482E";
createNode mesh -n "breakingcrate_geo75_physicsShape" -p "breakingcrate_geo75_physics";
	rename -uid "BD5BBC8F-429A-4255-84C0-66BF5F025ECA";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr -s 10 ".vt[0:9]"  -32.11177444 22.71138573 31.27892303 -37.097164154 7.20095348 31.27892113
		 -37.097164154 22.71138573 -8.019542694 -32.11177444 7.93329096 -10.18011093 -32.11177444 7.20095348 31.27892113
		 -37.097164154 22.71138573 31.27892303 -32.11177444 22.71138573 -3.35767889 -32.11177444 7.20095348 -10.28869438
		 -37.097164154 22.41065979 -8.15837479 -37.097164154 7.20095062 -10.41352844;
	setAttr -s 15 ".ed[0:14]"  5 1 1 1 4 1 4 0 1 0 5 1 7 4 1 1 9 1 9 7 1
		 7 3 1 3 6 1 6 0 1 8 3 1 9 8 1 5 2 1 2 8 1 2 6 1;
	setAttr -s 7 -ch 30 ".fc[0:6]" -type "polyFaces" 
		f 4 0 1 2 3
		f 4 4 -2 5 6
		f 5 7 8 9 -3 -5
		f 4 10 -8 -7 11
		f 5 -12 -6 -1 12 13
		f 4 -14 14 -9 -11
		f 4 -15 -13 -4 -10;
	setAttr ".cd" -type "dataPolyComponent" Index_Data Edge 0 ;
	setAttr ".cvd" -type "dataPolyComponent" Index_Data Vertex 0 ;
	setAttr ".pd[0]" -type "dataPolyComponent" Index_Data UV 0 ;
	setAttr ".hfd" -type "dataPolyComponent" Index_Data Face 0 ;
createNode lightLinker -s -n "lightLinker1";
	rename -uid "C0503EA6-491F-E1BC-8685-5489BEB5E8D9";
	setAttr -s 4 ".lnk";
	setAttr -s 4 ".slnk";
createNode shapeEditorManager -n "shapeEditorManager";
	rename -uid "7E07242A-435A-1B0B-97CA-6A89EACED820";
createNode poseInterpolatorManager -n "poseInterpolatorManager";
	rename -uid "B224C3D2-49CE-1C0E-D1A4-C196E3FAB26B";
createNode displayLayerManager -n "layerManager";
	rename -uid "09D3C5E2-4D26-60A5-6306-C0A117C929F6";
	setAttr ".cdl" 2;
	setAttr -s 3 ".dli[1:2]"  1 2;
	setAttr -s 3 ".dli";
createNode displayLayer -n "defaultLayer";
	rename -uid "A5FDCFB9-4413-E471-D450-F39CD8933706";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "F2B82EC9-4715-5D88-8711-2C9357CDDAAA";
createNode renderLayer -n "defaultRenderLayer";
	rename -uid "B2302A24-4C59-FAE7-6D1D-2EB61B386719";
	setAttr ".g" yes;
createNode script -n "uiConfigurationScriptNode";
	rename -uid "70A90DCC-435D-2612-7270-54997F8F695E";
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
		+ "            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"vPlanarDisplay\" 1 \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            -pluginObjects \"vRigWidget\" 1 \n            -pluginObjects \"vChainDisplay\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Persp View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"wireframe\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 1\n                -headsUpDisplay 1\n                -holdOuts 1\n                -selectionHiliteDisplay 1\n"
		+ "                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 32768\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -depthOfFieldPreview 1\n                -maxConstantTransparency 1\n                -rendererName \"vp2Renderer\" \n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 256 256 \n                -bumpResolution 512 512 \n"
		+ "                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n"
		+ "                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 1635\n                -height 1292\n                -sceneRenderFilter 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n                -pluginObjects \"vPlanarDisplay\" 1 \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                -pluginObjects \"vRigWidget\" 1 \n                -pluginObjects \"vChainDisplay\" 1 \n"
		+ "                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"persp\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"wireframe\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 1\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n"
		+ "            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n"
		+ "            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 1\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 1635\n            -height 1292\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n"
		+ "        modelEditor -e \n            -pluginObjects \"vPlanarDisplay\" 1 \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            -pluginObjects \"vRigWidget\" 1 \n            -pluginObjects \"vChainDisplay\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"outlinerPanel\" (localizedPanelLabel(\"Outliner\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `outlinerPanel -unParent -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            outlinerEditor -e \n                -docTag \"isolOutln_fromSeln\" \n                -showShapes 0\n                -showAssignedMaterials 0\n                -showReferenceNodes 1\n                -showReferenceMembers 1\n                -showAttributes 0\n                -showConnected 0\n                -showAnimCurvesOnly 0\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n"
		+ "                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 1\n                -showAssets 1\n                -showContainedOnly 1\n                -showPublishedAsConnected 0\n                -showContainerContents 1\n                -ignoreDagHierarchy 0\n                -expandConnections 0\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 0\n                -highlightActive 1\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"defaultSetFilter\" \n                -showSetMembers 1\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -isSet 0\n                -isSetMember 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n"
		+ "                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 0\n                -ignoreHiddenAttribute 1\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                -renderFilterIndex 0\n                -selectionOrder \"chronological\" \n                -expandAttribute 0\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\toutlinerPanel -edit -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        outlinerEditor -e \n            -docTag \"isolOutln_fromSeln\" \n"
		+ "            -showShapes 0\n            -showAssignedMaterials 0\n            -showReferenceNodes 1\n            -showReferenceMembers 1\n            -showAttributes 0\n            -showConnected 0\n            -showAnimCurvesOnly 0\n            -showMuteInfo 0\n            -organizeByLayer 1\n            -showAnimLayerWeight 1\n            -autoExpandLayers 1\n            -autoExpand 0\n            -showDagOnly 1\n            -showAssets 1\n            -showContainedOnly 1\n            -showPublishedAsConnected 0\n            -showContainerContents 1\n            -ignoreDagHierarchy 0\n            -expandConnections 0\n            -showUpstreamCurves 1\n            -showUnitlessCurves 1\n            -showCompounds 1\n            -showLeafs 1\n            -showNumericAttrsOnly 0\n            -highlightActive 1\n            -autoSelectNewObjects 0\n            -doNotSelectNewObjects 0\n            -dropIsParent 1\n            -transmitFilters 0\n            -setFilter \"defaultSetFilter\" \n            -showSetMembers 1\n            -allowMultiSelection 1\n"
		+ "            -alwaysToggleSelect 0\n            -directSelect 0\n            -isSet 0\n            -isSetMember 0\n            -displayMode \"DAG\" \n            -expandObjects 0\n            -setsIgnoreFilters 1\n            -containersIgnoreFilters 0\n            -editAttrName 0\n            -showAttrValues 0\n            -highlightSecondary 0\n            -showUVAttrsOnly 0\n            -showTextureNodesOnly 0\n            -attrAlphaOrder \"default\" \n            -animLayerFilterOptions \"allAffecting\" \n            -sortOrder \"none\" \n            -longNames 0\n            -niceNames 1\n            -showNamespace 1\n            -showPinIcons 0\n            -mapMotionTrails 0\n            -ignoreHiddenAttribute 1\n            -ignoreOutlinerColor 0\n            -renderFilterVisible 0\n            -renderFilterIndex 0\n            -selectionOrder \"chronological\" \n            -expandAttribute 0\n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"graphEditor\" (localizedPanelLabel(\"Graph Editor\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"graphEditor\" -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n"
		+ "                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 1\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 1\n                -mapMotionTrails 1\n"
		+ "                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 1\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -showResults \"off\" \n                -showBufferCurves \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1\n                -resultScreenSamples 0\n                -resultUpdate \"delayed\" \n                -showUpstreamCurves 1\n                -showCurveNames 0\n                -showActiveCurveNames 0\n                -stackedCurves 0\n                -stackedCurvesMin -1\n                -stackedCurvesMax 1\n                -stackedCurvesSpace 0.2\n                -displayNormalized 0\n"
		+ "                -preSelectionHighlight 0\n                -constrainDrag 0\n                -classicMode 1\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n"
		+ "                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 1\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n"
		+ "                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 1\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 1\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -showResults \"off\" \n                -showBufferCurves \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1\n                -resultScreenSamples 0\n                -resultUpdate \"delayed\" \n                -showUpstreamCurves 1\n                -showCurveNames 0\n                -showActiveCurveNames 0\n                -stackedCurves 0\n"
		+ "                -stackedCurvesMin -1\n                -stackedCurvesMax 1\n                -stackedCurvesSpace 0.2\n                -displayNormalized 0\n                -preSelectionHighlight 0\n                -constrainDrag 0\n                -classicMode 1\n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dopeSheetPanel\" (localizedPanelLabel(\"Dope Sheet\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dopeSheetPanel\" -l (localizedPanelLabel(\"Dope Sheet\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n"
		+ "                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 0\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 1\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n"
		+ "                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"DopeSheetEd\");\n            dopeSheetEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -outliner \"dopeSheetPanel1OutlineEd\" \n"
		+ "                -showSummary 1\n                -showScene 0\n                -hierarchyBelow 0\n                -showTicks 1\n                -selectionWindow 0 0 0 0 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Dope Sheet\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n"
		+ "                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 0\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 1\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n"
		+ "                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"DopeSheetEd\");\n            dopeSheetEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -outliner \"dopeSheetPanel1OutlineEd\" \n                -showSummary 1\n                -showScene 0\n                -hierarchyBelow 0\n                -showTicks 1\n                -selectionWindow 0 0 0 0 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n"
		+ "\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"clipEditorPanel\" (localizedPanelLabel(\"Trax Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"clipEditorPanel\" -l (localizedPanelLabel(\"Trax Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = clipEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -initialized 0\n                -manageSequencer 0 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Trax Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = clipEditorNameFromPanel($panelName);\n            clipEditor -e \n"
		+ "                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -displayValues 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -initialized 0\n                -manageSequencer 0 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"sequenceEditorPanel\" (localizedPanelLabel(\"Camera Sequencer\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"sequenceEditorPanel\" -l (localizedPanelLabel(\"Camera Sequencer\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = sequenceEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n"
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
		+ "                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 0\n                -height 0\n                -sceneRenderFilter 0\n                -displayMode \"centerEye\" \n                -viewColor 0 0 0 1 \n                -useCustomBackground 1\n                $editorName;\n            stereoCameraView -e -viewSelected 0 $editorName;\n            stereoCameraView -e \n                -pluginObjects \"vPlanarDisplay\" 1 \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                -pluginObjects \"vRigWidget\" 1 \n                -pluginObjects \"vChainDisplay\" 1 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Nightshade UV Editor Pro v2.1.3\")) `;\n"
		+ "\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Nightshade UV Editor Pro v2.1.3\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"wireframe\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -holdOuts 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 1\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n"
		+ "                -textureDisplay \"modulate\" \n                -textureMaxSize 32768\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -depthOfFieldPreview 1\n                -maxConstantTransparency 1\n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 4 4 \n                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n"
		+ "                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n"
		+ "                -greasePencils 1\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 0\n                -height 0\n                -sceneRenderFilter 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n                -pluginObjects \"vPlanarDisplay\" 1 \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                -pluginObjects \"vRigWidget\" 1 \n                -pluginObjects \"vChainDisplay\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Nightshade UV Editor Pro v2.1.3\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"persp\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"wireframe\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n"
		+ "            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 1\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 4 4 \n            -bumpResolution 4 4 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n"
		+ "            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 0\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n"
		+ "            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 1\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 0\n            -height 0\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"vPlanarDisplay\" 1 \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            -pluginObjects \"vRigWidget\" 1 \n            -pluginObjects \"vChainDisplay\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"hyperShadePanel\" (localizedPanelLabel(\"Hypershade\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"hyperShadePanel\" -l (localizedPanelLabel(\"Hypershade\")) -mbv $menusOkayInPanels `;\n"
		+ "\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Hypershade\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"nodeEditorPanel\" (localizedPanelLabel(\"Node Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"nodeEditorPanel\" -l (localizedPanelLabel(\"Node Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"NodeEditorEd\");\n            nodeEditor -e \n                -allAttributes 0\n                -allNodes 0\n                -autoSizeNodes 1\n                -consistentNameSize 1\n                -createNodeCommand \"nodeEdCreateNodeCommand\" \n                -defaultPinnedState 0\n                -additiveGraphingMode 0\n                -settingsChangedCallback \"nodeEdSyncControls\" \n                -traversalDepthLimit -1\n                -keyPressCommand \"nodeEdKeyPressCommand\" \n"
		+ "                -nodeTitleMode \"name\" \n                -gridSnap 0\n                -gridVisibility 1\n                -popupMenuScript \"nodeEdBuildPanelMenus\" \n                -showNamespace 1\n                -showShapes 1\n                -showSGShapes 0\n                -showTransforms 1\n                -useAssets 1\n                -syncedSelection 1\n                -extendToShapes 1\n                -activeTab -1\n                -editorMode \"default\" \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Node Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"NodeEditorEd\");\n            nodeEditor -e \n                -allAttributes 0\n                -allNodes 0\n                -autoSizeNodes 1\n                -consistentNameSize 1\n                -createNodeCommand \"nodeEdCreateNodeCommand\" \n                -defaultPinnedState 0\n                -additiveGraphingMode 0\n                -settingsChangedCallback \"nodeEdSyncControls\" \n"
		+ "                -traversalDepthLimit -1\n                -keyPressCommand \"nodeEdKeyPressCommand\" \n                -nodeTitleMode \"name\" \n                -gridSnap 0\n                -gridVisibility 1\n                -popupMenuScript \"nodeEdBuildPanelMenus\" \n                -showNamespace 1\n                -showShapes 1\n                -showSGShapes 0\n                -showTransforms 1\n                -useAssets 1\n                -syncedSelection 1\n                -extendToShapes 1\n                -activeTab -1\n                -editorMode \"default\" \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\tif ($useSceneConfig) {\n        string $configName = `getPanel -cwl (localizedPanelLabel(\"Current Layout\"))`;\n        if (\"\" != $configName) {\n\t\t\tpanelConfiguration -edit -label (localizedPanelLabel(\"Current Layout\")) \n\t\t\t\t-defaultImage \"vacantCell.xP:/\"\n\t\t\t\t-image \"\"\n\t\t\t\t-sc false\n\t\t\t\t-configString \"global string $gMainPane; paneLayout -e -cn \\\"vertical2\\\" -ps 1 21 100 -ps 2 79 100 $gMainPane;\"\n"
		+ "\t\t\t\t-removeAllPanels\n\t\t\t\t-ap false\n\t\t\t\t\t(localizedPanelLabel(\"Outliner\")) \n\t\t\t\t\t\"outlinerPanel\"\n\t\t\t\t\t\"$panelName = `outlinerPanel -unParent -l (localizedPanelLabel(\\\"Outliner\\\")) -mbv $menusOkayInPanels `;\\n$editorName = $panelName;\\noutlinerEditor -e \\n    -docTag \\\"isolOutln_fromSeln\\\" \\n    -showShapes 0\\n    -showAssignedMaterials 0\\n    -showReferenceNodes 1\\n    -showReferenceMembers 1\\n    -showAttributes 0\\n    -showConnected 0\\n    -showAnimCurvesOnly 0\\n    -showMuteInfo 0\\n    -organizeByLayer 1\\n    -showAnimLayerWeight 1\\n    -autoExpandLayers 1\\n    -autoExpand 0\\n    -showDagOnly 1\\n    -showAssets 1\\n    -showContainedOnly 1\\n    -showPublishedAsConnected 0\\n    -showContainerContents 1\\n    -ignoreDagHierarchy 0\\n    -expandConnections 0\\n    -showUpstreamCurves 1\\n    -showUnitlessCurves 1\\n    -showCompounds 1\\n    -showLeafs 1\\n    -showNumericAttrsOnly 0\\n    -highlightActive 1\\n    -autoSelectNewObjects 0\\n    -doNotSelectNewObjects 0\\n    -dropIsParent 1\\n    -transmitFilters 0\\n    -setFilter \\\"defaultSetFilter\\\" \\n    -showSetMembers 1\\n    -allowMultiSelection 1\\n    -alwaysToggleSelect 0\\n    -directSelect 0\\n    -isSet 0\\n    -isSetMember 0\\n    -displayMode \\\"DAG\\\" \\n    -expandObjects 0\\n    -setsIgnoreFilters 1\\n    -containersIgnoreFilters 0\\n    -editAttrName 0\\n    -showAttrValues 0\\n    -highlightSecondary 0\\n    -showUVAttrsOnly 0\\n    -showTextureNodesOnly 0\\n    -attrAlphaOrder \\\"default\\\" \\n    -animLayerFilterOptions \\\"allAffecting\\\" \\n    -sortOrder \\\"none\\\" \\n    -longNames 0\\n    -niceNames 1\\n    -showNamespace 1\\n    -showPinIcons 0\\n    -mapMotionTrails 0\\n    -ignoreHiddenAttribute 1\\n    -ignoreOutlinerColor 0\\n    -renderFilterVisible 0\\n    -renderFilterIndex 0\\n    -selectionOrder \\\"chronological\\\" \\n    -expandAttribute 0\\n    $editorName\"\n"
		+ "\t\t\t\t\t\"outlinerPanel -edit -l (localizedPanelLabel(\\\"Outliner\\\")) -mbv $menusOkayInPanels  $panelName;\\n$editorName = $panelName;\\noutlinerEditor -e \\n    -docTag \\\"isolOutln_fromSeln\\\" \\n    -showShapes 0\\n    -showAssignedMaterials 0\\n    -showReferenceNodes 1\\n    -showReferenceMembers 1\\n    -showAttributes 0\\n    -showConnected 0\\n    -showAnimCurvesOnly 0\\n    -showMuteInfo 0\\n    -organizeByLayer 1\\n    -showAnimLayerWeight 1\\n    -autoExpandLayers 1\\n    -autoExpand 0\\n    -showDagOnly 1\\n    -showAssets 1\\n    -showContainedOnly 1\\n    -showPublishedAsConnected 0\\n    -showContainerContents 1\\n    -ignoreDagHierarchy 0\\n    -expandConnections 0\\n    -showUpstreamCurves 1\\n    -showUnitlessCurves 1\\n    -showCompounds 1\\n    -showLeafs 1\\n    -showNumericAttrsOnly 0\\n    -highlightActive 1\\n    -autoSelectNewObjects 0\\n    -doNotSelectNewObjects 0\\n    -dropIsParent 1\\n    -transmitFilters 0\\n    -setFilter \\\"defaultSetFilter\\\" \\n    -showSetMembers 1\\n    -allowMultiSelection 1\\n    -alwaysToggleSelect 0\\n    -directSelect 0\\n    -isSet 0\\n    -isSetMember 0\\n    -displayMode \\\"DAG\\\" \\n    -expandObjects 0\\n    -setsIgnoreFilters 1\\n    -containersIgnoreFilters 0\\n    -editAttrName 0\\n    -showAttrValues 0\\n    -highlightSecondary 0\\n    -showUVAttrsOnly 0\\n    -showTextureNodesOnly 0\\n    -attrAlphaOrder \\\"default\\\" \\n    -animLayerFilterOptions \\\"allAffecting\\\" \\n    -sortOrder \\\"none\\\" \\n    -longNames 0\\n    -niceNames 1\\n    -showNamespace 1\\n    -showPinIcons 0\\n    -mapMotionTrails 0\\n    -ignoreHiddenAttribute 1\\n    -ignoreOutlinerColor 0\\n    -renderFilterVisible 0\\n    -renderFilterIndex 0\\n    -selectionOrder \\\"chronological\\\" \\n    -expandAttribute 0\\n    $editorName\"\n"
		+ "\t\t\t\t-ap false\n\t\t\t\t\t(localizedPanelLabel(\"Persp View\")) \n\t\t\t\t\t\"modelPanel\"\n"
		+ "\t\t\t\t\t\"$panelName = `modelPanel -unParent -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels `;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -cam `findStartUpCamera persp` \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"wireframe\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 1\\n    -headsUpDisplay 1\\n    -holdOuts 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 0\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 32768\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -depthOfFieldPreview 1\\n    -maxConstantTransparency 1\\n    -rendererName \\\"vp2Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 1\\n    -hulls 1\\n    -grid 1\\n    -imagePlane 1\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -particleInstancers 1\\n    -fluids 1\\n    -hairSystems 1\\n    -follicles 1\\n    -nCloths 1\\n    -nParticles 1\\n    -nRigids 1\\n    -dynamicConstraints 1\\n    -locators 1\\n    -manipulators 1\\n    -pluginShapes 1\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -motionTrails 1\\n    -clipGhosts 1\\n    -greasePencils 1\\n    -shadows 0\\n    -captureSequenceNumber -1\\n    -width 1635\\n    -height 1292\\n    -sceneRenderFilter 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"vPlanarDisplay\\\" 1 \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    -pluginObjects \\\"vRigWidget\\\" 1 \\n    -pluginObjects \\\"vChainDisplay\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t\t\"modelPanel -edit -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels  $panelName;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -cam `findStartUpCamera persp` \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"wireframe\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 1\\n    -headsUpDisplay 1\\n    -holdOuts 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 0\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 32768\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -depthOfFieldPreview 1\\n    -maxConstantTransparency 1\\n    -rendererName \\\"vp2Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 1\\n    -hulls 1\\n    -grid 1\\n    -imagePlane 1\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -particleInstancers 1\\n    -fluids 1\\n    -hairSystems 1\\n    -follicles 1\\n    -nCloths 1\\n    -nParticles 1\\n    -nRigids 1\\n    -dynamicConstraints 1\\n    -locators 1\\n    -manipulators 1\\n    -pluginShapes 1\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -motionTrails 1\\n    -clipGhosts 1\\n    -greasePencils 1\\n    -shadows 0\\n    -captureSequenceNumber -1\\n    -width 1635\\n    -height 1292\\n    -sceneRenderFilter 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"vPlanarDisplay\\\" 1 \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    -pluginObjects \\\"vRigWidget\\\" 1 \\n    -pluginObjects \\\"vChainDisplay\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t$configName;\n\n            setNamedPanelLayout (localizedPanelLabel(\"Current Layout\"));\n        }\n\n        panelHistory -e -clear mainPanelHistory;\n        setFocus `paneLayout -q -p1 $gMainPane`;\n        sceneUIReplacement -deleteRemaining;\n        sceneUIReplacement -clear;\n\t}\n\n\ngrid -spacing 5 -size 12 -divisions 5 -displayAxes yes -displayGridLines yes -displayDivisionLines yes -displayPerspectiveLabels no -displayOrthographicLabels no -displayAxesBold yes -perspectiveLabelPosition axis -orthographicLabelPosition edge;\nviewManip -drawCompass 0 -compassAngle 0 -frontParameters \"\" -homeParameters \"\" -selectionLockParameters \"\";\n}\n");
	setAttr ".st" 3;
createNode script -n "sceneConfigurationScriptNode";
	rename -uid "32190443-4466-6BCE-F6E5-8AAE49A4B836";
	setAttr ".b" -type "string" "playbackOptions -min 1 -max 120 -ast 1 -aet 200 ";
	setAttr ".st" 6;
createNode renderLayer -s -n "globalRender";
	rename -uid "C06E7383-4275-D589-DAC0-1180FB95CE52";
createNode vsVmatToTex -n "breakingcrate_vsVmatToTex_ND1";
	rename -uid "6748ED86-4849-B4AA-126D-C89672E21392";
	setAttr ".vmat" -type "string" "materials/models/gameplay/breakingcrate.vmat";
createNode reference -n "breakingcrate_vmatRN1";
	rename -uid "DCCC2978-459F-A60F-585E-9CA34954CA47";
	setAttr -s 25 ".phl";
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
	setAttr ".ed" -type "dataReferenceEdits" 
		"breakingcrate_vmatRN1"
		"breakingcrate_vmatRN1" 0
		"breakingcrate_vmatRN1" 27
		1 breakingcrate_vmat1:dota2_hero_shaderfx "FBX_vmatPath" "FBX_vmatPath" " -ci 1 -nn \"FBX_vmatPath\" -dt \"string\""
		
		2 "breakingcrate_vmat1:dota2_hero_shaderfx" "shaderparams" " -type \"string\" \"fresnelWarpColor~278~fresnelWarpRim~278~fresnelWarpSpec~278~cubeMap~278~color~278~normal~278~specularMask~278~specularColor~319~specularExponent~317~specularScale~317~rimMask~278~rimLightColor~319~rimLightScale~317~selfIllumMask~278~translucency~278~metalnessMask~278~cubeMapScalar~317~\""
		
		5 3 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.message" 
		"breakingcrate_vmatRN1.placeHolderList[1]" ""
		5 3 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.message" 
		"breakingcrate_vmatRN1.placeHolderList[2]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.FBX_vmatPath" 
		"breakingcrate_vmatRN1.placeHolderList[3]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.fresnelWarpColor" 
		"breakingcrate_vmatRN1.placeHolderList[4]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.fresnelWarpRim" 
		"breakingcrate_vmatRN1.placeHolderList[5]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.fresnelWarpSpec" 
		"breakingcrate_vmatRN1.placeHolderList[6]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.cubeMap" 
		"breakingcrate_vmatRN1.placeHolderList[7]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.color" 
		"breakingcrate_vmatRN1.placeHolderList[8]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.normal" 
		"breakingcrate_vmatRN1.placeHolderList[9]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.specularMask" 
		"breakingcrate_vmatRN1.placeHolderList[10]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.specularColorR" 
		"breakingcrate_vmatRN1.placeHolderList[11]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.specularColorG" 
		"breakingcrate_vmatRN1.placeHolderList[12]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.specularColorB" 
		"breakingcrate_vmatRN1.placeHolderList[13]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.specularExponent" 
		"breakingcrate_vmatRN1.placeHolderList[14]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.specularScale" 
		"breakingcrate_vmatRN1.placeHolderList[15]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.rimMask" 
		"breakingcrate_vmatRN1.placeHolderList[16]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.rimLightColorR" 
		"breakingcrate_vmatRN1.placeHolderList[17]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.rimLightColorG" 
		"breakingcrate_vmatRN1.placeHolderList[18]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.rimLightColorB" 
		"breakingcrate_vmatRN1.placeHolderList[19]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.rimLightScale" 
		"breakingcrate_vmatRN1.placeHolderList[20]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.selfIllumMask" 
		"breakingcrate_vmatRN1.placeHolderList[21]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.translucency" 
		"breakingcrate_vmatRN1.placeHolderList[22]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.metalnessMask" 
		"breakingcrate_vmatRN1.placeHolderList[23]" ""
		5 4 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.cubeMapScalar" 
		"breakingcrate_vmatRN1.placeHolderList[24]" ""
		5 3 "breakingcrate_vmatRN1" "breakingcrate_vmat1:dota2_hero_shaderfx.outColor" 
		"breakingcrate_vmatRN1.placeHolderList[25]" "";
lockNode -l 1 ;
createNode shadingEngine -n "breakingcrate_vmat1:dota2_hero_shaderfxSG";
	rename -uid "AF0EC830-417C-D2AD-84AA-B7B78FDF84E6";
	setAttr ".ihi" 0;
	setAttr -s 13 ".dsm";
	setAttr ".ro" yes;
	setAttr -s 13 ".gn";
createNode materialInfo -n "materialInfo3";
	rename -uid "077D1EDA-4EBE-B500-C73E-3993981A4EDC";
createNode lambert -n "lambert2";
	rename -uid "35F97937-4E4A-3451-8D67-E4825D393D54";
createNode shadingEngine -n "lambert2SG";
	rename -uid "EA5AADB2-44A6-E045-0CD2-3C86AB927798";
	setAttr ".ihi" 0;
	setAttr ".ro" yes;
createNode materialInfo -n "materialInfo4";
	rename -uid "1247A13E-41DA-3C63-33A8-33A6F7F52878";
createNode file -n "file1";
	rename -uid "77F5C9ED-4573-0A67-6E94-2989E34AD5F6";
	setAttr ".ftn" -type "string" "D:/dev/source2/main/content/dota_addons/dungeon/materials/models/gameplay/breakingcrate_color.psd";
	setAttr ".cs" -type "string" "sRGB";
createNode place2dTexture -n "place2dTexture1";
	rename -uid "1F67703D-4529-CBC5-238C-669E80EA365D";
createNode nodeGraphEditorInfo -n "hyperShadePrimaryNodeEditorSavedTabsInfo";
	rename -uid "55A3D68B-4E14-6F46-3DDA-F8B434EDC608";
	setAttr ".tgi[0].tn" -type "string" "Untitled_1";
	setAttr ".tgi[0].vl" -type "double2" -740.19183542740336 -625.14003864074959 ;
	setAttr ".tgi[0].vh" -type "double2" 728.9173261205965 673.17925267346754 ;
	setAttr -s 6 ".tgi[0].ni";
	setAttr ".tgi[0].ni[0].x" 222.85714721679687;
	setAttr ".tgi[0].ni[0].y" -394.28570556640625;
	setAttr ".tgi[0].ni[0].nvs" 1923;
	setAttr ".tgi[0].ni[1].x" 222.85714721679687;
	setAttr ".tgi[0].ni[1].y" -210;
	setAttr ".tgi[0].ni[1].nvs" 1923;
	setAttr ".tgi[0].ni[2].x" 222.85714721679687;
	setAttr ".tgi[0].ni[2].y" 255.71427917480469;
	setAttr ".tgi[0].ni[2].nvs" 1923;
	setAttr ".tgi[0].ni[3].x" -84.285713195800781;
	setAttr ".tgi[0].ni[3].y" 255.71427917480469;
	setAttr ".tgi[0].ni[3].nvs" 1923;
	setAttr ".tgi[0].ni[4].x" -84.285713195800781;
	setAttr ".tgi[0].ni[4].y" -301.42855834960937;
	setAttr ".tgi[0].ni[4].nvs" 1923;
	setAttr ".tgi[0].ni[5].x" -427.14285278320312;
	setAttr ".tgi[0].ni[5].y" 611.4285888671875;
	setAttr ".tgi[0].ni[5].nvs" 1922;
createNode skinCluster -n "skinCluster1";
	rename -uid "BB759D08-4900-1268-C3A4-8DBDE4CE7DC2";
	setAttr -s 56 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -0.58651542663574219 -3.519098393619061 0 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId184";
	rename -uid "40028802-4F0A-27A5-1EB0-9EB4CF32D1F9";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts1";
	rename -uid "F89C5B5D-45D6-6886-6EC7-AF9E656D276F";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:41]";
createNode groupId -n "groupId185";
	rename -uid "37EB6BF4-4FB6-2400-4501-949F1C769DB7";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts2";
	rename -uid "F1D90CD4-4593-F001-D03F-73B31793C1F6";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:41]";
createNode tweak -n "tweak1";
	rename -uid "D78C420C-4332-2449-21C0-57BB6ACF39F5";
createNode objectSet -n "skinCluster1Set";
	rename -uid "80C2C76E-4929-9066-D743-C2A7EAFF824E";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster1GroupId";
	rename -uid "059C5AE7-4587-DEE4-1576-239663F8DEF1";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster1GroupParts";
	rename -uid "8293B936-4FF8-22BE-1E39-DF9B87B4B2C2";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet1";
	rename -uid "AE869486-4B84-8109-D368-05820CCA3B2B";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId187";
	rename -uid "E411D7B4-4B38-682A-B757-95BDC70F8BF4";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts4";
	rename -uid "ED9705E3-44D9-5506-5903-739889F66A6B";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose1";
	rename -uid "D076FB46-4799-64D9-37FA-F98CB078FFFB";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 0.58651542663574219 3.519098393619061
		 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster2";
	rename -uid "DC7DD7D1-40ED-8F39-7530-3A8CA7217733";
	setAttr -s 71 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".wl[60].w[0]"  1;
	setAttr ".wl[61].w[0]"  1;
	setAttr ".wl[62].w[0]"  1;
	setAttr ".wl[63].w[0]"  1;
	setAttr ".wl[64].w[0]"  1;
	setAttr ".wl[65].w[0]"  1;
	setAttr ".wl[66].w[0]"  1;
	setAttr ".wl[67].w[0]"  1;
	setAttr ".wl[68].w[0]"  1;
	setAttr ".wl[69].w[0]"  1;
	setAttr ".wl[70].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 10.957788467407228 -55.005126953125007 -36.663144111633301 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId188";
	rename -uid "9F06212C-4466-0F8E-1D2C-93A9873B91A7";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts5";
	rename -uid "D675709B-402D-DF50-2708-1482BC51E2D7";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 2 "f[0:9]" "f[22:46]";
createNode groupId -n "groupId189";
	rename -uid "5DB986F1-4D53-046D-3CE2-59A22346D781";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts6";
	rename -uid "8FEAEF37-4527-A907-5BED-46BBA55ECFBD";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:46]";
createNode tweak -n "tweak2";
	rename -uid "0C4B8BC8-4A67-E7A6-525A-AC8E8AE46DAB";
createNode objectSet -n "skinCluster2Set";
	rename -uid "2D8EB75A-46FE-A15E-83EB-D7AA61000FCF";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster2GroupId";
	rename -uid "610EE0AB-45A8-C5FD-64BB-F6A523A71CB2";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster2GroupParts";
	rename -uid "AE0820F1-4544-483F-9633-FB827A00FDE5";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet2";
	rename -uid "D102D13A-4D5F-EFF7-34BF-ADB336DE485F";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId191";
	rename -uid "300CE22A-4573-F6A2-AA06-B5A696D9FDF9";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts8";
	rename -uid "3E4DAADD-45F1-F7D7-1159-7AB7F25FD988";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose2";
	rename -uid "93DC846F-485D-D022-F19A-F388089EDD49";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -10.957788467407228 55.005126953125007 36.663144111633301 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 -10.957788467407228 55.005126953125007
		 36.663144111633301 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster3";
	rename -uid "8B870ADA-4D4B-10A9-338C-73B027B781EF";
	setAttr -s 51 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 13.207149505615233 -23.346709251403809 -36.663144111633301 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId192";
	rename -uid "6B24A609-4E16-626C-A7FA-EDA865D805CA";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts9";
	rename -uid "BB9BC575-4C59-E718-C841-E6926DBBEFC4";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:24]";
createNode groupId -n "groupId193";
	rename -uid "880BFF67-402B-3833-12A3-72AEC8D4D60B";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts10";
	rename -uid "D96031E6-40DC-5DC9-10AC-48B28A82B35B";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:36]";
createNode tweak -n "tweak3";
	rename -uid "0FB655C0-452A-A475-4F9A-089118955F7E";
createNode objectSet -n "skinCluster3Set";
	rename -uid "D796DE7D-46DB-C0D2-9479-A5B6B3E78126";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster3GroupId";
	rename -uid "168A98F3-4582-9FA5-1820-D4878E822DC3";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster3GroupParts";
	rename -uid "092B851C-4FF3-611C-35E0-E88795D80E24";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet3";
	rename -uid "9B9030BE-4108-1C7C-8B9B-BC879B4A60C2";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId195";
	rename -uid "B5528B2A-4A27-A148-821F-B5859A370472";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts12";
	rename -uid "BA058999-4FD1-F732-361D-F682C9D97E45";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose3";
	rename -uid "54FE6F41-405F-0976-E97F-0D8008BDB424";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -13.207149505615233 23.346709251403809 36.663144111633301 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 -13.207149505615233 23.346709251403809
		 36.663144111633301 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster4";
	rename -uid "850F1E15-49E7-A3CD-A851-FDAF743F9978";
	setAttr -s 96 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".wl[60].w[0]"  1;
	setAttr ".wl[61].w[0]"  1;
	setAttr ".wl[62].w[0]"  1;
	setAttr ".wl[63].w[0]"  1;
	setAttr ".wl[64].w[0]"  1;
	setAttr ".wl[65].w[0]"  1;
	setAttr ".wl[66].w[0]"  1;
	setAttr ".wl[67].w[0]"  1;
	setAttr ".wl[68].w[0]"  1;
	setAttr ".wl[69].w[0]"  1;
	setAttr ".wl[70].w[0]"  1;
	setAttr ".wl[71].w[0]"  1;
	setAttr ".wl[72].w[0]"  1;
	setAttr ".wl[73].w[0]"  1;
	setAttr ".wl[74].w[0]"  1;
	setAttr ".wl[75].w[0]"  1;
	setAttr ".wl[76].w[0]"  1;
	setAttr ".wl[77].w[0]"  1;
	setAttr ".wl[78].w[0]"  1;
	setAttr ".wl[79].w[0]"  1;
	setAttr ".wl[80].w[0]"  1;
	setAttr ".wl[81].w[0]"  1;
	setAttr ".wl[82].w[0]"  1;
	setAttr ".wl[83].w[0]"  1;
	setAttr ".wl[84].w[0]"  1;
	setAttr ".wl[85].w[0]"  1;
	setAttr ".wl[86].w[0]"  1;
	setAttr ".wl[87].w[0]"  1;
	setAttr ".wl[88].w[0]"  1;
	setAttr ".wl[89].w[0]"  1;
	setAttr ".wl[90].w[0]"  1;
	setAttr ".wl[91].w[0]"  1;
	setAttr ".wl[92].w[0]"  1;
	setAttr ".wl[93].w[0]"  1;
	setAttr ".wl[94].w[0]"  1;
	setAttr ".wl[95].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -7.9282169342041016 -43.402218818664551 -36.663144111633301 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId196";
	rename -uid "279F9B5C-4DE6-79A7-92EA-4D9BB12EE08C";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts13";
	rename -uid "FC37BF44-467F-8E8E-E796-D1BED7A37EAD";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:65]";
createNode groupId -n "groupId197";
	rename -uid "BEE32997-445E-4CA0-11C9-93AF06F4FAC3";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts14";
	rename -uid "11E196AD-4E9C-3438-FA55-7A8533ACA6C3";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:65]";
createNode tweak -n "tweak4";
	rename -uid "2E340515-4331-74D4-5491-DBAD8DB617D4";
createNode objectSet -n "skinCluster4Set";
	rename -uid "E9BAA84B-4886-DA40-2B7E-4CA2C9A91C94";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster4GroupId";
	rename -uid "A224055B-4BAE-9E70-76FC-1EBFECBAAD22";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster4GroupParts";
	rename -uid "0A5E0A93-4CB2-836F-DCB6-A399B403A82D";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet4";
	rename -uid "14E92AD0-4D0B-8342-3458-48B9871F5F70";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId199";
	rename -uid "BFE25F61-4228-3424-23FA-C0B053F3A7FC";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts16";
	rename -uid "1C890BB6-47AA-A988-C3DF-F482055570CF";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose4";
	rename -uid "D85E2FFB-423A-0803-202E-5792FB92723A";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 7.9282169342041016 43.402218818664551 36.663144111633301 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 7.9282169342041016 43.402218818664551
		 36.663144111633301 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster5";
	rename -uid "D5992CE4-4C28-C22F-7D39-0CB53451A179";
	setAttr -s 91 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".wl[60].w[0]"  1;
	setAttr ".wl[61].w[0]"  1;
	setAttr ".wl[62].w[0]"  1;
	setAttr ".wl[63].w[0]"  1;
	setAttr ".wl[64].w[0]"  1;
	setAttr ".wl[65].w[0]"  1;
	setAttr ".wl[66].w[0]"  1;
	setAttr ".wl[67].w[0]"  1;
	setAttr ".wl[68].w[0]"  1;
	setAttr ".wl[69].w[0]"  1;
	setAttr ".wl[70].w[0]"  1;
	setAttr ".wl[71].w[0]"  1;
	setAttr ".wl[72].w[0]"  1;
	setAttr ".wl[73].w[0]"  1;
	setAttr ".wl[74].w[0]"  1;
	setAttr ".wl[75].w[0]"  1;
	setAttr ".wl[76].w[0]"  1;
	setAttr ".wl[77].w[0]"  1;
	setAttr ".wl[78].w[0]"  1;
	setAttr ".wl[79].w[0]"  1;
	setAttr ".wl[80].w[0]"  1;
	setAttr ".wl[81].w[0]"  1;
	setAttr ".wl[82].w[0]"  1;
	setAttr ".wl[83].w[0]"  1;
	setAttr ".wl[84].w[0]"  1;
	setAttr ".wl[85].w[0]"  1;
	setAttr ".wl[86].w[0]"  1;
	setAttr ".wl[87].w[0]"  1;
	setAttr ".wl[88].w[0]"  1;
	setAttr ".wl[89].w[0]"  1;
	setAttr ".wl[90].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -8.8519010543823242 -82.218948364257798 0.58651733398437489 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId200";
	rename -uid "9F402897-4906-09F2-7B37-BE879BAB40E2";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts17";
	rename -uid "519CEBFB-4EE1-A35F-06B6-66BAC1482DA3";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:61]";
createNode groupId -n "groupId201";
	rename -uid "AC96C6C6-469F-39D9-18B4-AFAF2BBB5847";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts18";
	rename -uid "13766A9E-49D8-9CE9-B677-4AB7DC9ACF0E";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:61]";
createNode tweak -n "tweak5";
	rename -uid "679C8B3F-4CB8-D7E1-FE22-3AB4E9A65109";
createNode objectSet -n "skinCluster5Set";
	rename -uid "B0861B72-492D-2B26-EC8A-EEAE901C6DD2";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster5GroupId";
	rename -uid "499C2131-413D-CE7C-8EA0-12835BEBAFBC";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster5GroupParts";
	rename -uid "2805D536-43E4-9CD7-A542-09A56FA97F26";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet5";
	rename -uid "619F2CC9-481E-6886-E999-47AE876C8C27";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId203";
	rename -uid "66CA054C-457A-F81E-7A36-BB854C1DB2B0";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts20";
	rename -uid "BA9B242E-4331-7B11-C36E-568EA73553E4";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose5";
	rename -uid "019CF216-45BB-6ACD-D6F1-B6814A853D29";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 8.8519010543823242 82.218948364257798 -0.58651733398437489 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 8.8519010543823242 82.218948364257798
		 -0.58651733398437489 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster6";
	rename -uid "A0A36F56-49E1-212E-31F7-8EBDE357C873";
	setAttr -s 96 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".wl[60].w[0]"  1;
	setAttr ".wl[61].w[0]"  1;
	setAttr ".wl[62].w[0]"  1;
	setAttr ".wl[63].w[0]"  1;
	setAttr ".wl[64].w[0]"  1;
	setAttr ".wl[65].w[0]"  1;
	setAttr ".wl[66].w[0]"  1;
	setAttr ".wl[67].w[0]"  1;
	setAttr ".wl[68].w[0]"  1;
	setAttr ".wl[69].w[0]"  1;
	setAttr ".wl[70].w[0]"  1;
	setAttr ".wl[71].w[0]"  1;
	setAttr ".wl[72].w[0]"  1;
	setAttr ".wl[73].w[0]"  1;
	setAttr ".wl[74].w[0]"  1;
	setAttr ".wl[75].w[0]"  1;
	setAttr ".wl[76].w[0]"  1;
	setAttr ".wl[77].w[0]"  1;
	setAttr ".wl[78].w[0]"  1;
	setAttr ".wl[79].w[0]"  1;
	setAttr ".wl[80].w[0]"  1;
	setAttr ".wl[81].w[0]"  1;
	setAttr ".wl[82].w[0]"  1;
	setAttr ".wl[83].w[0]"  1;
	setAttr ".wl[84].w[0]"  1;
	setAttr ".wl[85].w[0]"  1;
	setAttr ".wl[86].w[0]"  1;
	setAttr ".wl[87].w[0]"  1;
	setAttr ".wl[88].w[0]"  1;
	setAttr ".wl[89].w[0]"  1;
	setAttr ".wl[90].w[0]"  1;
	setAttr ".wl[91].w[0]"  1;
	setAttr ".wl[92].w[0]"  1;
	setAttr ".wl[93].w[0]"  1;
	setAttr ".wl[94].w[0]"  1;
	setAttr ".wl[95].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -37.029716491699219 -43.402213335037231 -12.228683948516846 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId204";
	rename -uid "D61FDCD6-45C5-B7EE-4306-4B8B5378BADE";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts21";
	rename -uid "38F238CC-4403-4776-FA45-A0988874DA7E";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:64]";
createNode groupId -n "groupId205";
	rename -uid "32AC8F7E-44B3-6A0E-C069-198D5EF7B3F5";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts22";
	rename -uid "AE821482-4F96-8A7E-FD33-7C99E53C3B28";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:64]";
createNode tweak -n "tweak6";
	rename -uid "E15DFBF8-43B7-DE25-6844-9C88AD2BF934";
createNode objectSet -n "skinCluster6Set";
	rename -uid "8CF6EA41-41C6-5FC2-AA52-73B2FC8002B7";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster6GroupId";
	rename -uid "47C6E1F0-46A1-1695-9C90-4C8BD7DE4CE6";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster6GroupParts";
	rename -uid "6F0F1DCF-4EDC-CE38-A5D3-1486EF879C83";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet6";
	rename -uid "AF99513D-4550-E697-02F9-9B8486CEBAE6";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId207";
	rename -uid "9AC4769F-481A-EC6E-AE38-37AEAE714E42";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts24";
	rename -uid "E4E835B1-4D8E-72EA-9141-F8851E978B1F";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose6";
	rename -uid "F3FAD4C8-4CEC-1CC0-09F1-17B2E1E72098";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 37.029716491699219 43.402213335037231 12.228683948516846 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 37.029716491699219 43.402213335037231
		 12.228683948516846 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster7";
	rename -uid "3DFC105E-4D1C-FAE7-6274-D88E6A2B87FC";
	setAttr -s 96 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".wl[60].w[0]"  1;
	setAttr ".wl[61].w[0]"  1;
	setAttr ".wl[62].w[0]"  1;
	setAttr ".wl[63].w[0]"  1;
	setAttr ".wl[64].w[0]"  1;
	setAttr ".wl[65].w[0]"  1;
	setAttr ".wl[66].w[0]"  1;
	setAttr ".wl[67].w[0]"  1;
	setAttr ".wl[68].w[0]"  1;
	setAttr ".wl[69].w[0]"  1;
	setAttr ".wl[70].w[0]"  1;
	setAttr ".wl[71].w[0]"  1;
	setAttr ".wl[72].w[0]"  1;
	setAttr ".wl[73].w[0]"  1;
	setAttr ".wl[74].w[0]"  1;
	setAttr ".wl[75].w[0]"  1;
	setAttr ".wl[76].w[0]"  1;
	setAttr ".wl[77].w[0]"  1;
	setAttr ".wl[78].w[0]"  1;
	setAttr ".wl[79].w[0]"  1;
	setAttr ".wl[80].w[0]"  1;
	setAttr ".wl[81].w[0]"  1;
	setAttr ".wl[82].w[0]"  1;
	setAttr ".wl[83].w[0]"  1;
	setAttr ".wl[84].w[0]"  1;
	setAttr ".wl[85].w[0]"  1;
	setAttr ".wl[86].w[0]"  1;
	setAttr ".wl[87].w[0]"  1;
	setAttr ".wl[88].w[0]"  1;
	setAttr ".wl[89].w[0]"  1;
	setAttr ".wl[90].w[0]"  1;
	setAttr ".wl[91].w[0]"  1;
	setAttr ".wl[92].w[0]"  1;
	setAttr ".wl[93].w[0]"  1;
	setAttr ".wl[94].w[0]"  1;
	setAttr ".wl[95].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -37.029716491699219 -43.402213335037231 14.332284450531008 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId208";
	rename -uid "CA49E77C-4A54-A9F4-9CB5-77B0A88D3A8C";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts25";
	rename -uid "CEFAB5AD-4B47-B0CD-784E-D39504E99923";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:64]";
createNode groupId -n "groupId209";
	rename -uid "58894D2A-431A-ABFB-1F12-0BB603FFE968";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts26";
	rename -uid "BDA18DF1-4F4A-1BC0-0DBC-D8A1518D5322";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:64]";
createNode tweak -n "tweak7";
	rename -uid "568296F0-4A9F-2338-F9CF-E58E80FD8B2B";
createNode objectSet -n "skinCluster7Set";
	rename -uid "E23A3319-4D8C-1D09-433D-BDB7BEFADF00";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster7GroupId";
	rename -uid "050E3019-48C5-C27B-03AC-9EA0AC5D05AE";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster7GroupParts";
	rename -uid "F8F4A96E-4288-E958-F2D1-5BB2B33E0506";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet7";
	rename -uid "C7736F7B-4396-DBB3-CA4A-2597B84E4C33";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId211";
	rename -uid "DB41D348-4E55-4109-6164-B4BF25E24ED4";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts28";
	rename -uid "15E24F71-4D1E-EC26-7DCF-5986AC3696E8";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose7";
	rename -uid "8694B842-4A77-EDB6-6229-E1A33475FD1B";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 37.029716491699219 43.402213335037231 -14.332284450531008 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 37.029716491699219 43.402213335037231
		 -14.332284450531008 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster8";
	rename -uid "FA2BCCB4-4189-B141-6E1A-62A6270C8E99";
	setAttr -s 88 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".wl[60].w[0]"  1;
	setAttr ".wl[61].w[0]"  1;
	setAttr ".wl[62].w[0]"  1;
	setAttr ".wl[63].w[0]"  1;
	setAttr ".wl[64].w[0]"  1;
	setAttr ".wl[65].w[0]"  1;
	setAttr ".wl[66].w[0]"  1;
	setAttr ".wl[67].w[0]"  1;
	setAttr ".wl[68].w[0]"  1;
	setAttr ".wl[69].w[0]"  1;
	setAttr ".wl[70].w[0]"  1;
	setAttr ".wl[71].w[0]"  1;
	setAttr ".wl[72].w[0]"  1;
	setAttr ".wl[73].w[0]"  1;
	setAttr ".wl[74].w[0]"  1;
	setAttr ".wl[75].w[0]"  1;
	setAttr ".wl[76].w[0]"  1;
	setAttr ".wl[77].w[0]"  1;
	setAttr ".wl[78].w[0]"  1;
	setAttr ".wl[79].w[0]"  1;
	setAttr ".wl[80].w[0]"  1;
	setAttr ".wl[81].w[0]"  1;
	setAttr ".wl[82].w[0]"  1;
	setAttr ".wl[83].w[0]"  1;
	setAttr ".wl[84].w[0]"  1;
	setAttr ".wl[85].w[0]"  1;
	setAttr ".wl[86].w[0]"  1;
	setAttr ".wl[87].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -7.154974937438964 -43.402216911315918 36.956401824951172 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId212";
	rename -uid "15EDEF3C-431D-897F-F78F-CAB0C6CB0916";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts29";
	rename -uid "C8DFAE26-40FE-6055-560A-B79B89776062";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:56]";
createNode groupId -n "groupId213";
	rename -uid "A9FA4455-4F6E-0DA6-0E16-7499FC5B9EFE";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts30";
	rename -uid "2A7FF360-4415-951C-8546-C0A317F36CF6";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:56]";
createNode tweak -n "tweak8";
	rename -uid "5DA72B3E-4AC2-AAAF-1850-9C9B94B8478A";
createNode objectSet -n "skinCluster8Set";
	rename -uid "55529BC5-4FFA-8C6E-16D2-6EB1EE4D8F9E";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster8GroupId";
	rename -uid "9CADA807-4C00-ED43-2584-5283DD916DD1";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster8GroupParts";
	rename -uid "50930040-4BED-6CB7-2F2D-BB9698A22170";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet8";
	rename -uid "643957CC-41C0-FE7A-7363-19BC00DE4630";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId215";
	rename -uid "BDB8D485-43C3-E2CD-8FBB-85BC7543F2F6";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts32";
	rename -uid "C24AA1DE-420E-5670-8E6F-56A1174F8931";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose8";
	rename -uid "A91C8562-4FD0-D821-33AB-ED99433DD717";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 7.154974937438964 43.402216911315918 -36.956401824951172 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 7.154974937438964 43.402216911315918
		 -36.956401824951172 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster9";
	rename -uid "D5709FE0-4E9D-3CDC-EB2B-36B1D4EA60F4";
	setAttr -s 48 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 17.808063745498657 -25.081090211868283 37.249660491943352 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId216";
	rename -uid "A427A96E-421A-55DF-4A00-899BA705B1C9";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts33";
	rename -uid "A0D939E9-409B-CFD0-C404-DA993A450764";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:30]";
createNode groupId -n "groupId217";
	rename -uid "93605912-4140-680C-F08D-9CB9C9541BEB";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts34";
	rename -uid "0AD3BBC2-4A9B-ED3E-07FA-8289B85DB7FD";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:30]";
createNode tweak -n "tweak9";
	rename -uid "186C8E8E-4139-8E13-8CE0-47BB3BE5B23E";
createNode objectSet -n "skinCluster9Set";
	rename -uid "31354255-48D4-1408-D940-70B863C11453";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster9GroupId";
	rename -uid "849A86B4-4E84-3B05-8BCA-D9B9D11CA738";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster9GroupParts";
	rename -uid "24E04B8E-4C68-6DAA-6E2E-4BA7245148F4";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet9";
	rename -uid "BBE57C00-466F-C83B-4087-4780B19630E9";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId219";
	rename -uid "9A8A7CCC-46B0-4535-D483-2EA6CFF3750C";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts36";
	rename -uid "87E2A252-4DB4-14D7-CA14-A781DC043B0F";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose9";
	rename -uid "854261E8-478C-F1E9-4BA7-1D88D2F9C3D8";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -17.808063745498657 25.081090211868283 -37.249660491943352 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 -17.808063745498657 25.081090211868283
		 -37.249660491943352 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster10";
	rename -uid "F56E1570-4C2E-8102-18DF-27932F954E2F";
	setAttr -s 60 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 6.5793962478637695 -58.13042068481446 36.956401824951172 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId220";
	rename -uid "EFED611C-470A-E53B-1FEF-48B5B19566EF";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts37";
	rename -uid "9196370A-4371-1486-5561-9DBC91923420";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:37]";
createNode groupId -n "groupId221";
	rename -uid "FE38BCD0-4D5F-8BCC-A6DC-718810B47649";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts38";
	rename -uid "6A36F996-420D-4305-3EF2-34BB41E20CFC";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:37]";
createNode tweak -n "tweak10";
	rename -uid "43AA6AFB-4AAC-5D7B-048F-8FB2E9981E50";
createNode objectSet -n "skinCluster10Set";
	rename -uid "AECDF484-40B0-8C9E-D734-32A9CC7FF292";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster10GroupId";
	rename -uid "660EE445-43BA-061A-ABD9-D683595BD5B5";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster10GroupParts";
	rename -uid "042FCD2C-44D8-3608-E651-90895BD82C38";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet10";
	rename -uid "1818A61F-4BAF-0F20-D1A0-5B860CBC6D97";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId223";
	rename -uid "E3E48B33-43C2-47C7-FB70-E98467654B72";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts40";
	rename -uid "1119D3A2-49F2-0061-9CC7-C08843F440B7";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose10";
	rename -uid "B56AEF24-4938-CE52-1D26-998D73F746CE";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -6.5793962478637695 58.13042068481446 -36.956401824951172 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 -6.5793962478637695 58.13042068481446
		 -36.956401824951172 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster11";
	rename -uid "8165949C-4642-DED2-0FD4-56BE7492874D";
	setAttr -s 93 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".wl[60].w[0]"  1;
	setAttr ".wl[61].w[0]"  1;
	setAttr ".wl[62].w[0]"  1;
	setAttr ".wl[63].w[0]"  1;
	setAttr ".wl[64].w[0]"  1;
	setAttr ".wl[65].w[0]"  1;
	setAttr ".wl[66].w[0]"  1;
	setAttr ".wl[67].w[0]"  1;
	setAttr ".wl[68].w[0]"  1;
	setAttr ".wl[69].w[0]"  1;
	setAttr ".wl[70].w[0]"  1;
	setAttr ".wl[71].w[0]"  1;
	setAttr ".wl[72].w[0]"  1;
	setAttr ".wl[73].w[0]"  1;
	setAttr ".wl[74].w[0]"  1;
	setAttr ".wl[75].w[0]"  1;
	setAttr ".wl[76].w[0]"  1;
	setAttr ".wl[77].w[0]"  1;
	setAttr ".wl[78].w[0]"  1;
	setAttr ".wl[79].w[0]"  1;
	setAttr ".wl[80].w[0]"  1;
	setAttr ".wl[81].w[0]"  1;
	setAttr ".wl[82].w[0]"  1;
	setAttr ".wl[83].w[0]"  1;
	setAttr ".wl[84].w[0]"  1;
	setAttr ".wl[85].w[0]"  1;
	setAttr ".wl[86].w[0]"  1;
	setAttr ".wl[87].w[0]"  1;
	setAttr ".wl[88].w[0]"  1;
	setAttr ".wl[89].w[0]"  1;
	setAttr ".wl[90].w[0]"  1;
	setAttr ".wl[91].w[0]"  1;
	setAttr ".wl[92].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 9.5819339752197266 -82.25341796875 0.0014324188232421877 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId224";
	rename -uid "1D214813-4431-6297-6602-579D0A3EDEE9";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts41";
	rename -uid "0D960C70-4304-5C9C-D07A-FD9F0884B485";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:62]";
createNode groupId -n "groupId225";
	rename -uid "7DADEB45-4A86-BC7C-C025-A8AE0AC9F21C";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts42";
	rename -uid "57DACF51-4828-1531-3DEC-3783236DE218";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:62]";
createNode tweak -n "tweak11";
	rename -uid "3904336D-461B-893F-64D2-698A87CD86A0";
createNode objectSet -n "skinCluster11Set";
	rename -uid "75E2F689-4E18-5C56-EC98-6B92E749BCE4";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster11GroupId";
	rename -uid "49084AF5-4141-5D0E-5AE9-0C814B3297D8";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster11GroupParts";
	rename -uid "F5B28902-428D-14A4-FD7F-7DA6A730C3F6";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet11";
	rename -uid "7E86AD9F-4C01-2494-0EB6-14993F125DAD";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId227";
	rename -uid "4C1B7344-4842-8274-4701-D1B04207335B";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts44";
	rename -uid "937762D6-434B-B9E6-D09A-AC92A6FE594E";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose11";
	rename -uid "3876180C-434E-9779-4744-ADB323F6C5E8";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -9.5819339752197266 82.25341796875 -0.0014324188232421877 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 -9.5819339752197266 82.25341796875
		 -0.0014324188232421877 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster12";
	rename -uid "47254B5A-41EA-CB78-6F2E-2087830F3ED6";
	setAttr -s 90 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".wl[60].w[0]"  1;
	setAttr ".wl[61].w[0]"  1;
	setAttr ".wl[62].w[0]"  1;
	setAttr ".wl[63].w[0]"  1;
	setAttr ".wl[64].w[0]"  1;
	setAttr ".wl[65].w[0]"  1;
	setAttr ".wl[66].w[0]"  1;
	setAttr ".wl[67].w[0]"  1;
	setAttr ".wl[68].w[0]"  1;
	setAttr ".wl[69].w[0]"  1;
	setAttr ".wl[70].w[0]"  1;
	setAttr ".wl[71].w[0]"  1;
	setAttr ".wl[72].w[0]"  1;
	setAttr ".wl[73].w[0]"  1;
	setAttr ".wl[74].w[0]"  1;
	setAttr ".wl[75].w[0]"  1;
	setAttr ".wl[76].w[0]"  1;
	setAttr ".wl[77].w[0]"  1;
	setAttr ".wl[78].w[0]"  1;
	setAttr ".wl[79].w[0]"  1;
	setAttr ".wl[80].w[0]"  1;
	setAttr ".wl[81].w[0]"  1;
	setAttr ".wl[82].w[0]"  1;
	setAttr ".wl[83].w[0]"  1;
	setAttr ".wl[84].w[0]"  1;
	setAttr ".wl[85].w[0]"  1;
	setAttr ".wl[86].w[0]"  1;
	setAttr ".wl[87].w[0]"  1;
	setAttr ".wl[88].w[0]"  1;
	setAttr ".wl[89].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 36.44320011138916 -43.402213335037224 14.213162899017332 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId228";
	rename -uid "34B924FF-4FFA-C84F-C55D-B48AB6D9FF38";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts45";
	rename -uid "FE192E66-4470-AC77-313B-BEA5188132E9";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:61]";
createNode groupId -n "groupId229";
	rename -uid "7C643943-4149-B62E-AE03-5AB20D7640A9";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts46";
	rename -uid "3A2212B1-45D3-C340-C52D-5D9EAE1C47DC";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:61]";
createNode tweak -n "tweak12";
	rename -uid "AAED757C-40D0-BC18-0E16-7683313FD71C";
createNode objectSet -n "skinCluster12Set";
	rename -uid "FAB17619-4551-5C7B-0BA2-ED8A861FC6CA";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster12GroupId";
	rename -uid "88A26BDD-4651-DA09-7EDB-2F86E3586558";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster12GroupParts";
	rename -uid "52EBC3C2-48C7-AF78-F978-54915F4A1F10";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet12";
	rename -uid "05F7E25C-416E-90A7-30B5-B282C2E33704";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId231";
	rename -uid "A6302391-4C8D-8044-BEE5-6EBD3D85E3F2";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts48";
	rename -uid "FB34CD16-468F-C6FD-B95A-96BE829A69B8";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose12";
	rename -uid "B025A96F-4C94-13BB-B0FF-8C9806B04899";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -36.44320011138916 43.402213335037224 -14.213162899017332 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 -36.44320011138916 43.402213335037224
		 -14.213162899017332 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode skinCluster -n "skinCluster13";
	rename -uid "0693BD4F-4820-ECA7-8FCC-EE990309FD3C";
	setAttr -s 90 ".wl";
	setAttr ".wl[0].w[0]"  1;
	setAttr ".wl[1].w[0]"  1;
	setAttr ".wl[2].w[0]"  1;
	setAttr ".wl[3].w[0]"  1;
	setAttr ".wl[4].w[0]"  1;
	setAttr ".wl[5].w[0]"  1;
	setAttr ".wl[6].w[0]"  1;
	setAttr ".wl[7].w[0]"  1;
	setAttr ".wl[8].w[0]"  1;
	setAttr ".wl[9].w[0]"  1;
	setAttr ".wl[10].w[0]"  1;
	setAttr ".wl[11].w[0]"  1;
	setAttr ".wl[12].w[0]"  1;
	setAttr ".wl[13].w[0]"  1;
	setAttr ".wl[14].w[0]"  1;
	setAttr ".wl[15].w[0]"  1;
	setAttr ".wl[16].w[0]"  1;
	setAttr ".wl[17].w[0]"  1;
	setAttr ".wl[18].w[0]"  1;
	setAttr ".wl[19].w[0]"  1;
	setAttr ".wl[20].w[0]"  1;
	setAttr ".wl[21].w[0]"  1;
	setAttr ".wl[22].w[0]"  1;
	setAttr ".wl[23].w[0]"  1;
	setAttr ".wl[24].w[0]"  1;
	setAttr ".wl[25].w[0]"  1;
	setAttr ".wl[26].w[0]"  1;
	setAttr ".wl[27].w[0]"  1;
	setAttr ".wl[28].w[0]"  1;
	setAttr ".wl[29].w[0]"  1;
	setAttr ".wl[30].w[0]"  1;
	setAttr ".wl[31].w[0]"  1;
	setAttr ".wl[32].w[0]"  1;
	setAttr ".wl[33].w[0]"  1;
	setAttr ".wl[34].w[0]"  1;
	setAttr ".wl[35].w[0]"  1;
	setAttr ".wl[36].w[0]"  1;
	setAttr ".wl[37].w[0]"  1;
	setAttr ".wl[38].w[0]"  1;
	setAttr ".wl[39].w[0]"  1;
	setAttr ".wl[40].w[0]"  1;
	setAttr ".wl[41].w[0]"  1;
	setAttr ".wl[42].w[0]"  1;
	setAttr ".wl[43].w[0]"  1;
	setAttr ".wl[44].w[0]"  1;
	setAttr ".wl[45].w[0]"  1;
	setAttr ".wl[46].w[0]"  1;
	setAttr ".wl[47].w[0]"  1;
	setAttr ".wl[48].w[0]"  1;
	setAttr ".wl[49].w[0]"  1;
	setAttr ".wl[50].w[0]"  1;
	setAttr ".wl[51].w[0]"  1;
	setAttr ".wl[52].w[0]"  1;
	setAttr ".wl[53].w[0]"  1;
	setAttr ".wl[54].w[0]"  1;
	setAttr ".wl[55].w[0]"  1;
	setAttr ".wl[56].w[0]"  1;
	setAttr ".wl[57].w[0]"  1;
	setAttr ".wl[58].w[0]"  1;
	setAttr ".wl[59].w[0]"  1;
	setAttr ".wl[60].w[0]"  1;
	setAttr ".wl[61].w[0]"  1;
	setAttr ".wl[62].w[0]"  1;
	setAttr ".wl[63].w[0]"  1;
	setAttr ".wl[64].w[0]"  1;
	setAttr ".wl[65].w[0]"  1;
	setAttr ".wl[66].w[0]"  1;
	setAttr ".wl[67].w[0]"  1;
	setAttr ".wl[68].w[0]"  1;
	setAttr ".wl[69].w[0]"  1;
	setAttr ".wl[70].w[0]"  1;
	setAttr ".wl[71].w[0]"  1;
	setAttr ".wl[72].w[0]"  1;
	setAttr ".wl[73].w[0]"  1;
	setAttr ".wl[74].w[0]"  1;
	setAttr ".wl[75].w[0]"  1;
	setAttr ".wl[76].w[0]"  1;
	setAttr ".wl[77].w[0]"  1;
	setAttr ".wl[78].w[0]"  1;
	setAttr ".wl[79].w[0]"  1;
	setAttr ".wl[80].w[0]"  1;
	setAttr ".wl[81].w[0]"  1;
	setAttr ".wl[82].w[0]"  1;
	setAttr ".wl[83].w[0]"  1;
	setAttr ".wl[84].w[0]"  1;
	setAttr ".wl[85].w[0]"  1;
	setAttr ".wl[86].w[0]"  1;
	setAttr ".wl[87].w[0]"  1;
	setAttr ".wl[88].w[0]"  1;
	setAttr ".wl[89].w[0]"  1;
	setAttr ".pm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 36.44320011138916 -43.402213335037224 -9.9553966522216797 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".dpf[0]"  4;
	setAttr ".mmi" yes;
	setAttr ".mi" 4;
	setAttr ".ucm" yes;
createNode groupId -n "groupId232";
	rename -uid "37DC848A-4E1B-8E7C-E52D-CAA84D317A24";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts49";
	rename -uid "4504AC21-4C64-D30E-8F15-88BA2C102685";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:61]";
createNode groupId -n "groupId233";
	rename -uid "B478DF8B-4028-D57D-7CA3-7BAD5A56DC0D";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts50";
	rename -uid "4BF725D2-4DC8-01A1-B2AF-21B98954D912";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "f[0:61]";
createNode tweak -n "tweak13";
	rename -uid "980FE52B-4430-C8F6-A025-B399B53BB544";
createNode objectSet -n "skinCluster13Set";
	rename -uid "B475845E-4AE6-16D1-3707-82AE3340D4D1";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster13GroupId";
	rename -uid "B75D72C6-4FE6-32DE-7CE9-9C87A2675D32";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster13GroupParts";
	rename -uid "52AEF261-4A0D-4A72-290F-58824A23A5ED";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet13";
	rename -uid "883D5BD1-4A17-B443-D30B-1DA10838E760";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId235";
	rename -uid "408F4537-4FDE-9652-1AAF-5BB9403EF037";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts52";
	rename -uid "594142CB-436B-BE94-1EEC-D3B916FF64D8";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose13";
	rename -uid "FFA6060C-4D82-1278-9E82-66AD8E24BD9A";
	setAttr -s 2 ".wm";
	setAttr ".wm[0]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;
	setAttr ".wm[1]" -type "matrix" 1 0 0 0 0 1 0 0 0 0 1 0 -36.44320011138916 43.402213335037224 9.9553966522216797 1;
	setAttr -s 2 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 -36.44320011138916 43.402213335037224
		 9.9553966522216797 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 yes;
	setAttr -s 2 ".m";
	setAttr -s 2 ".p";
	setAttr -s 2 ".g[0:1]" yes no;
	setAttr ".bp" yes;
createNode vstExportNode -n "breakingcrate_dest_exportNode";
	rename -uid "B68C2285-4F74-9A12-21E4-159F8B3442F6";
	setAttr ".ei[0].exportFile" -type "string" "breakingcrate_dest";
	setAttr ".ei[0].fs" 1;
	setAttr ".ei[0].fe" 120;
createNode displayLayer -n "GEO";
	rename -uid "CCF6E1DF-413C-6147-E7C1-DB853F268881";
	setAttr ".dt" 2;
	setAttr ".do" 1;
createNode displayLayer -n "JOINTS";
	rename -uid "A00465BD-4A98-0290-33CD-66BCCCB707E8";
	setAttr ".dt" 2;
	setAttr ".do" 2;
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
	setAttr -s 2 ".r";
select -ne :defaultTextureList1;
select -ne :initialShadingGroup;
	setAttr -av -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -av -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 82 ".dsm";
	setAttr -k on ".mwc";
	setAttr -cb on ".an";
	setAttr -cb on ".il";
	setAttr -cb on ".vo";
	setAttr -cb on ".eo";
	setAttr -cb on ".fo";
	setAttr -cb on ".epo";
	setAttr -k on ".ro";
	setAttr -s 13 ".gn";
connectAttr "breakingcrate_vmatRN1.phl[1]" "materialInfo3.m";
connectAttr "breakingcrate_vmatRN1.phl[2]" "hyperShadePrimaryNodeEditorSavedTabsInfo.tgi[0].ni[3].dn"
		;
connectAttr "breakingcrate_vsVmatToTex_ND1.vmat" "breakingcrate_vmatRN1.phl[3]";
connectAttr "breakingcrate_vsVmatToTex_ND1.fwc" "breakingcrate_vmatRN1.phl[4]";
connectAttr "breakingcrate_vsVmatToTex_ND1.fwr" "breakingcrate_vmatRN1.phl[5]";
connectAttr "breakingcrate_vsVmatToTex_ND1.fws" "breakingcrate_vmatRN1.phl[6]";
connectAttr "breakingcrate_vsVmatToTex_ND1.cm" "breakingcrate_vmatRN1.phl[7]";
connectAttr "breakingcrate_vsVmatToTex_ND1.clr" "breakingcrate_vmatRN1.phl[8]";
connectAttr "breakingcrate_vsVmatToTex_ND1.norm" "breakingcrate_vmatRN1.phl[9]";
connectAttr "breakingcrate_vsVmatToTex_ND1.sm" "breakingcrate_vmatRN1.phl[10]";
connectAttr "breakingcrate_vsVmatToTex_ND1.sc0" "breakingcrate_vmatRN1.phl[11]";
connectAttr "breakingcrate_vsVmatToTex_ND1.sc1" "breakingcrate_vmatRN1.phl[12]";
connectAttr "breakingcrate_vsVmatToTex_ND1.sc2" "breakingcrate_vmatRN1.phl[13]";
connectAttr "breakingcrate_vsVmatToTex_ND1.se" "breakingcrate_vmatRN1.phl[14]";
connectAttr "breakingcrate_vsVmatToTex_ND1.ss" "breakingcrate_vmatRN1.phl[15]";
connectAttr "breakingcrate_vsVmatToTex_ND1.rm" "breakingcrate_vmatRN1.phl[16]";
connectAttr "breakingcrate_vsVmatToTex_ND1.rlc0" "breakingcrate_vmatRN1.phl[17]"
		;
connectAttr "breakingcrate_vsVmatToTex_ND1.rlc1" "breakingcrate_vmatRN1.phl[18]"
		;
connectAttr "breakingcrate_vsVmatToTex_ND1.rlc2" "breakingcrate_vmatRN1.phl[19]"
		;
connectAttr "breakingcrate_vsVmatToTex_ND1.rls" "breakingcrate_vmatRN1.phl[20]";
connectAttr "breakingcrate_vsVmatToTex_ND1.sim" "breakingcrate_vmatRN1.phl[21]";
connectAttr "breakingcrate_vsVmatToTex_ND1.trans" "breakingcrate_vmatRN1.phl[22]"
		;
connectAttr "breakingcrate_vsVmatToTex_ND1.mm" "breakingcrate_vmatRN1.phl[23]";
connectAttr "breakingcrate_vsVmatToTex_ND1.cms" "breakingcrate_vmatRN1.phl[24]";
connectAttr "breakingcrate_vmatRN1.phl[25]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.ss"
		;
connectAttr "JOINTS.di" "breakingcrate_joints.do";
connectAttr "breakingcrate_joint1_parentConstraint1.ctx" "breakingcrate_joint1.tx"
		;
connectAttr "breakingcrate_joint1_parentConstraint1.cty" "breakingcrate_joint1.ty"
		;
connectAttr "breakingcrate_joint1_parentConstraint1.ctz" "breakingcrate_joint1.tz"
		;
connectAttr "breakingcrate_joint1_parentConstraint1.crx" "breakingcrate_joint1.rx"
		;
connectAttr "breakingcrate_joint1_parentConstraint1.cry" "breakingcrate_joint1.ry"
		;
connectAttr "breakingcrate_joint1_parentConstraint1.crz" "breakingcrate_joint1.rz"
		;
connectAttr "breakingcrate_joint1.ro" "breakingcrate_joint1_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint1.pim" "breakingcrate_joint1_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint1.rp" "breakingcrate_joint1_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint1.rpt" "breakingcrate_joint1_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint1.jo" "breakingcrate_joint1_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc1.t" "breakingcrate_joint1_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc1.rp" "breakingcrate_joint1_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc1.rpt" "breakingcrate_joint1_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc1.r" "breakingcrate_joint1_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc1.ro" "breakingcrate_joint1_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc1.s" "breakingcrate_joint1_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc1.pm" "breakingcrate_joint1_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint1_parentConstraint1.w0" "breakingcrate_joint1_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint2_parentConstraint1.ctx" "breakingcrate_joint2.tx"
		;
connectAttr "breakingcrate_joint2_parentConstraint1.cty" "breakingcrate_joint2.ty"
		;
connectAttr "breakingcrate_joint2_parentConstraint1.ctz" "breakingcrate_joint2.tz"
		;
connectAttr "breakingcrate_joint2_parentConstraint1.crx" "breakingcrate_joint2.rx"
		;
connectAttr "breakingcrate_joint2_parentConstraint1.cry" "breakingcrate_joint2.ry"
		;
connectAttr "breakingcrate_joint2_parentConstraint1.crz" "breakingcrate_joint2.rz"
		;
connectAttr "breakingcrate_joint2.ro" "breakingcrate_joint2_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint2.pim" "breakingcrate_joint2_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint2.rp" "breakingcrate_joint2_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint2.rpt" "breakingcrate_joint2_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint2.jo" "breakingcrate_joint2_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc2.t" "breakingcrate_joint2_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc2.rp" "breakingcrate_joint2_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc2.rpt" "breakingcrate_joint2_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc2.r" "breakingcrate_joint2_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc2.ro" "breakingcrate_joint2_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc2.s" "breakingcrate_joint2_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc2.pm" "breakingcrate_joint2_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint2_parentConstraint1.w0" "breakingcrate_joint2_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint3_parentConstraint1.ctx" "breakingcrate_joint3.tx"
		;
connectAttr "breakingcrate_joint3_parentConstraint1.cty" "breakingcrate_joint3.ty"
		;
connectAttr "breakingcrate_joint3_parentConstraint1.ctz" "breakingcrate_joint3.tz"
		;
connectAttr "breakingcrate_joint3_parentConstraint1.crx" "breakingcrate_joint3.rx"
		;
connectAttr "breakingcrate_joint3_parentConstraint1.cry" "breakingcrate_joint3.ry"
		;
connectAttr "breakingcrate_joint3_parentConstraint1.crz" "breakingcrate_joint3.rz"
		;
connectAttr "breakingcrate_joint3.ro" "breakingcrate_joint3_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint3.pim" "breakingcrate_joint3_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint3.rp" "breakingcrate_joint3_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint3.rpt" "breakingcrate_joint3_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint3.jo" "breakingcrate_joint3_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc3.t" "breakingcrate_joint3_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc3.rp" "breakingcrate_joint3_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc3.rpt" "breakingcrate_joint3_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc3.r" "breakingcrate_joint3_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc3.ro" "breakingcrate_joint3_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc3.s" "breakingcrate_joint3_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc3.pm" "breakingcrate_joint3_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint3_parentConstraint1.w0" "breakingcrate_joint3_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint4_parentConstraint1.ctx" "breakingcrate_joint4.tx"
		;
connectAttr "breakingcrate_joint4_parentConstraint1.cty" "breakingcrate_joint4.ty"
		;
connectAttr "breakingcrate_joint4_parentConstraint1.ctz" "breakingcrate_joint4.tz"
		;
connectAttr "breakingcrate_joint4_parentConstraint1.crx" "breakingcrate_joint4.rx"
		;
connectAttr "breakingcrate_joint4_parentConstraint1.cry" "breakingcrate_joint4.ry"
		;
connectAttr "breakingcrate_joint4_parentConstraint1.crz" "breakingcrate_joint4.rz"
		;
connectAttr "breakingcrate_joint4.ro" "breakingcrate_joint4_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint4.pim" "breakingcrate_joint4_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint4.rp" "breakingcrate_joint4_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint4.rpt" "breakingcrate_joint4_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint4.jo" "breakingcrate_joint4_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc4.t" "breakingcrate_joint4_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc4.rp" "breakingcrate_joint4_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc4.rpt" "breakingcrate_joint4_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc4.r" "breakingcrate_joint4_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc4.ro" "breakingcrate_joint4_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc4.s" "breakingcrate_joint4_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc4.pm" "breakingcrate_joint4_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint4_parentConstraint1.w0" "breakingcrate_joint4_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint5_parentConstraint1.ctx" "breakingcrate_joint5.tx"
		;
connectAttr "breakingcrate_joint5_parentConstraint1.cty" "breakingcrate_joint5.ty"
		;
connectAttr "breakingcrate_joint5_parentConstraint1.ctz" "breakingcrate_joint5.tz"
		;
connectAttr "breakingcrate_joint5_parentConstraint1.crx" "breakingcrate_joint5.rx"
		;
connectAttr "breakingcrate_joint5_parentConstraint1.cry" "breakingcrate_joint5.ry"
		;
connectAttr "breakingcrate_joint5_parentConstraint1.crz" "breakingcrate_joint5.rz"
		;
connectAttr "breakingcrate_joint5.ro" "breakingcrate_joint5_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint5.pim" "breakingcrate_joint5_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint5.rp" "breakingcrate_joint5_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint5.rpt" "breakingcrate_joint5_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint5.jo" "breakingcrate_joint5_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc5.t" "breakingcrate_joint5_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc5.rp" "breakingcrate_joint5_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc5.rpt" "breakingcrate_joint5_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc5.r" "breakingcrate_joint5_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc5.ro" "breakingcrate_joint5_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc5.s" "breakingcrate_joint5_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc5.pm" "breakingcrate_joint5_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint5_parentConstraint1.w0" "breakingcrate_joint5_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint6_parentConstraint1.ctx" "breakingcrate_joint6.tx"
		;
connectAttr "breakingcrate_joint6_parentConstraint1.cty" "breakingcrate_joint6.ty"
		;
connectAttr "breakingcrate_joint6_parentConstraint1.ctz" "breakingcrate_joint6.tz"
		;
connectAttr "breakingcrate_joint6_parentConstraint1.crx" "breakingcrate_joint6.rx"
		;
connectAttr "breakingcrate_joint6_parentConstraint1.cry" "breakingcrate_joint6.ry"
		;
connectAttr "breakingcrate_joint6_parentConstraint1.crz" "breakingcrate_joint6.rz"
		;
connectAttr "breakingcrate_joint6.ro" "breakingcrate_joint6_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint6.pim" "breakingcrate_joint6_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint6.rp" "breakingcrate_joint6_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint6.rpt" "breakingcrate_joint6_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint6.jo" "breakingcrate_joint6_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc6.t" "breakingcrate_joint6_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc6.rp" "breakingcrate_joint6_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc6.rpt" "breakingcrate_joint6_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc6.r" "breakingcrate_joint6_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc6.ro" "breakingcrate_joint6_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc6.s" "breakingcrate_joint6_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc6.pm" "breakingcrate_joint6_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint6_parentConstraint1.w0" "breakingcrate_joint6_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint7_parentConstraint1.ctx" "breakingcrate_joint7.tx"
		;
connectAttr "breakingcrate_joint7_parentConstraint1.cty" "breakingcrate_joint7.ty"
		;
connectAttr "breakingcrate_joint7_parentConstraint1.ctz" "breakingcrate_joint7.tz"
		;
connectAttr "breakingcrate_joint7_parentConstraint1.crx" "breakingcrate_joint7.rx"
		;
connectAttr "breakingcrate_joint7_parentConstraint1.cry" "breakingcrate_joint7.ry"
		;
connectAttr "breakingcrate_joint7_parentConstraint1.crz" "breakingcrate_joint7.rz"
		;
connectAttr "breakingcrate_joint7.ro" "breakingcrate_joint7_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint7.pim" "breakingcrate_joint7_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint7.rp" "breakingcrate_joint7_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint7.rpt" "breakingcrate_joint7_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint7.jo" "breakingcrate_joint7_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc7.t" "breakingcrate_joint7_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc7.rp" "breakingcrate_joint7_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc7.rpt" "breakingcrate_joint7_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc7.r" "breakingcrate_joint7_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc7.ro" "breakingcrate_joint7_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc7.s" "breakingcrate_joint7_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc7.pm" "breakingcrate_joint7_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint7_parentConstraint1.w0" "breakingcrate_joint7_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint8_parentConstraint1.ctx" "breakingcrate_joint8.tx"
		;
connectAttr "breakingcrate_joint8_parentConstraint1.cty" "breakingcrate_joint8.ty"
		;
connectAttr "breakingcrate_joint8_parentConstraint1.ctz" "breakingcrate_joint8.tz"
		;
connectAttr "breakingcrate_joint8_parentConstraint1.crx" "breakingcrate_joint8.rx"
		;
connectAttr "breakingcrate_joint8_parentConstraint1.cry" "breakingcrate_joint8.ry"
		;
connectAttr "breakingcrate_joint8_parentConstraint1.crz" "breakingcrate_joint8.rz"
		;
connectAttr "breakingcrate_joint8.ro" "breakingcrate_joint8_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint8.pim" "breakingcrate_joint8_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint8.rp" "breakingcrate_joint8_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint8.rpt" "breakingcrate_joint8_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint8.jo" "breakingcrate_joint8_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc8.t" "breakingcrate_joint8_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc8.rp" "breakingcrate_joint8_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc8.rpt" "breakingcrate_joint8_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc8.r" "breakingcrate_joint8_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc8.ro" "breakingcrate_joint8_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc8.s" "breakingcrate_joint8_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc8.pm" "breakingcrate_joint8_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint8_parentConstraint1.w0" "breakingcrate_joint8_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint9_parentConstraint1.ctx" "breakingcrate_joint9.tx"
		;
connectAttr "breakingcrate_joint9_parentConstraint1.cty" "breakingcrate_joint9.ty"
		;
connectAttr "breakingcrate_joint9_parentConstraint1.ctz" "breakingcrate_joint9.tz"
		;
connectAttr "breakingcrate_joint9_parentConstraint1.crx" "breakingcrate_joint9.rx"
		;
connectAttr "breakingcrate_joint9_parentConstraint1.cry" "breakingcrate_joint9.ry"
		;
connectAttr "breakingcrate_joint9_parentConstraint1.crz" "breakingcrate_joint9.rz"
		;
connectAttr "breakingcrate_joint9.ro" "breakingcrate_joint9_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint9.pim" "breakingcrate_joint9_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint9.rp" "breakingcrate_joint9_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint9.rpt" "breakingcrate_joint9_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint9.jo" "breakingcrate_joint9_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc9.t" "breakingcrate_joint9_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc9.rp" "breakingcrate_joint9_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc9.rpt" "breakingcrate_joint9_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc9.r" "breakingcrate_joint9_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc9.ro" "breakingcrate_joint9_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc9.s" "breakingcrate_joint9_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc9.pm" "breakingcrate_joint9_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint9_parentConstraint1.w0" "breakingcrate_joint9_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint10_parentConstraint1.ctx" "breakingcrate_joint10.tx"
		;
connectAttr "breakingcrate_joint10_parentConstraint1.cty" "breakingcrate_joint10.ty"
		;
connectAttr "breakingcrate_joint10_parentConstraint1.ctz" "breakingcrate_joint10.tz"
		;
connectAttr "breakingcrate_joint10_parentConstraint1.crx" "breakingcrate_joint10.rx"
		;
connectAttr "breakingcrate_joint10_parentConstraint1.cry" "breakingcrate_joint10.ry"
		;
connectAttr "breakingcrate_joint10_parentConstraint1.crz" "breakingcrate_joint10.rz"
		;
connectAttr "breakingcrate_joint10.ro" "breakingcrate_joint10_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint10.pim" "breakingcrate_joint10_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint10.rp" "breakingcrate_joint10_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint10.rpt" "breakingcrate_joint10_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint10.jo" "breakingcrate_joint10_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc10.t" "breakingcrate_joint10_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc10.rp" "breakingcrate_joint10_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc10.rpt" "breakingcrate_joint10_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc10.r" "breakingcrate_joint10_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc10.ro" "breakingcrate_joint10_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc10.s" "breakingcrate_joint10_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc10.pm" "breakingcrate_joint10_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint10_parentConstraint1.w0" "breakingcrate_joint10_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint11_parentConstraint1.ctx" "breakingcrate_joint11.tx"
		;
connectAttr "breakingcrate_joint11_parentConstraint1.cty" "breakingcrate_joint11.ty"
		;
connectAttr "breakingcrate_joint11_parentConstraint1.ctz" "breakingcrate_joint11.tz"
		;
connectAttr "breakingcrate_joint11_parentConstraint1.crx" "breakingcrate_joint11.rx"
		;
connectAttr "breakingcrate_joint11_parentConstraint1.cry" "breakingcrate_joint11.ry"
		;
connectAttr "breakingcrate_joint11_parentConstraint1.crz" "breakingcrate_joint11.rz"
		;
connectAttr "breakingcrate_joint11.ro" "breakingcrate_joint11_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint11.pim" "breakingcrate_joint11_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint11.rp" "breakingcrate_joint11_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint11.rpt" "breakingcrate_joint11_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint11.jo" "breakingcrate_joint11_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc11.t" "breakingcrate_joint11_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc11.rp" "breakingcrate_joint11_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc11.rpt" "breakingcrate_joint11_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc11.r" "breakingcrate_joint11_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc11.ro" "breakingcrate_joint11_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc11.s" "breakingcrate_joint11_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc11.pm" "breakingcrate_joint11_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint11_parentConstraint1.w0" "breakingcrate_joint11_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint12_parentConstraint1.ctx" "breakingcrate_joint12.tx"
		;
connectAttr "breakingcrate_joint12_parentConstraint1.cty" "breakingcrate_joint12.ty"
		;
connectAttr "breakingcrate_joint12_parentConstraint1.ctz" "breakingcrate_joint12.tz"
		;
connectAttr "breakingcrate_joint12_parentConstraint1.crx" "breakingcrate_joint12.rx"
		;
connectAttr "breakingcrate_joint12_parentConstraint1.cry" "breakingcrate_joint12.ry"
		;
connectAttr "breakingcrate_joint12_parentConstraint1.crz" "breakingcrate_joint12.rz"
		;
connectAttr "breakingcrate_joint12.ro" "breakingcrate_joint12_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint12.pim" "breakingcrate_joint12_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint12.rp" "breakingcrate_joint12_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint12.rpt" "breakingcrate_joint12_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint12.jo" "breakingcrate_joint12_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc12.t" "breakingcrate_joint12_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc12.rp" "breakingcrate_joint12_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc12.rpt" "breakingcrate_joint12_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc12.r" "breakingcrate_joint12_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc12.ro" "breakingcrate_joint12_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc12.s" "breakingcrate_joint12_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc12.pm" "breakingcrate_joint12_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint12_parentConstraint1.w0" "breakingcrate_joint12_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_joint13_parentConstraint1.ctx" "breakingcrate_joint13.tx"
		;
connectAttr "breakingcrate_joint13_parentConstraint1.cty" "breakingcrate_joint13.ty"
		;
connectAttr "breakingcrate_joint13_parentConstraint1.ctz" "breakingcrate_joint13.tz"
		;
connectAttr "breakingcrate_joint13_parentConstraint1.crx" "breakingcrate_joint13.rx"
		;
connectAttr "breakingcrate_joint13_parentConstraint1.cry" "breakingcrate_joint13.ry"
		;
connectAttr "breakingcrate_joint13_parentConstraint1.crz" "breakingcrate_joint13.rz"
		;
connectAttr "breakingcrate_joint13.ro" "breakingcrate_joint13_parentConstraint1.cro"
		;
connectAttr "breakingcrate_joint13.pim" "breakingcrate_joint13_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_joint13.rp" "breakingcrate_joint13_parentConstraint1.crp"
		;
connectAttr "breakingcrate_joint13.rpt" "breakingcrate_joint13_parentConstraint1.crt"
		;
connectAttr "breakingcrate_joint13.jo" "breakingcrate_joint13_parentConstraint1.cjo"
		;
connectAttr "breakingcrate_loc13.t" "breakingcrate_joint13_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_loc13.rp" "breakingcrate_joint13_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_loc13.rpt" "breakingcrate_joint13_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_loc13.r" "breakingcrate_joint13_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_loc13.ro" "breakingcrate_joint13_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_loc13.s" "breakingcrate_joint13_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_loc13.pm" "breakingcrate_joint13_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_joint13_parentConstraint1.w0" "breakingcrate_joint13_parentConstraint1.tg[0].tw"
		;
connectAttr "GEO.di" "breakingcrate_geo.do";
connectAttr "skinCluster1.og[0]" "breakingcrate_mesh1Shape.i";
connectAttr "groupId184.id" "breakingcrate_mesh1Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh1Shape.iog.og[0].gco";
connectAttr "groupId185.id" "breakingcrate_mesh1Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh1Shape.iog.og[1].gco"
		;
connectAttr "skinCluster1GroupId.id" "breakingcrate_mesh1Shape.iog.og[2].gid";
connectAttr "skinCluster1Set.mwc" "breakingcrate_mesh1Shape.iog.og[2].gco";
connectAttr "groupId187.id" "breakingcrate_mesh1Shape.iog.og[3].gid";
connectAttr "tweakSet1.mwc" "breakingcrate_mesh1Shape.iog.og[3].gco";
connectAttr "tweak1.vl[0].vt[0]" "breakingcrate_mesh1Shape.twl";
connectAttr "skinCluster2.og[0]" "breakingcrate_mesh2Shape.i";
connectAttr "groupId188.id" "breakingcrate_mesh2Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh2Shape.iog.og[0].gco";
connectAttr "groupId189.id" "breakingcrate_mesh2Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh2Shape.iog.og[1].gco"
		;
connectAttr "skinCluster2GroupId.id" "breakingcrate_mesh2Shape.iog.og[2].gid";
connectAttr "skinCluster2Set.mwc" "breakingcrate_mesh2Shape.iog.og[2].gco";
connectAttr "groupId191.id" "breakingcrate_mesh2Shape.iog.og[3].gid";
connectAttr "tweakSet2.mwc" "breakingcrate_mesh2Shape.iog.og[3].gco";
connectAttr "tweak2.vl[0].vt[0]" "breakingcrate_mesh2Shape.twl";
connectAttr "skinCluster3.og[0]" "breakingcrate_mesh3Shape.i";
connectAttr "groupId192.id" "breakingcrate_mesh3Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh3Shape.iog.og[0].gco";
connectAttr "groupId193.id" "breakingcrate_mesh3Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh3Shape.iog.og[1].gco"
		;
connectAttr "skinCluster3GroupId.id" "breakingcrate_mesh3Shape.iog.og[2].gid";
connectAttr "skinCluster3Set.mwc" "breakingcrate_mesh3Shape.iog.og[2].gco";
connectAttr "groupId195.id" "breakingcrate_mesh3Shape.iog.og[3].gid";
connectAttr "tweakSet3.mwc" "breakingcrate_mesh3Shape.iog.og[3].gco";
connectAttr "tweak3.vl[0].vt[0]" "breakingcrate_mesh3Shape.twl";
connectAttr "skinCluster4.og[0]" "breakingcrate_mesh4Shape.i";
connectAttr "groupId196.id" "breakingcrate_mesh4Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh4Shape.iog.og[0].gco";
connectAttr "groupId197.id" "breakingcrate_mesh4Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh4Shape.iog.og[1].gco"
		;
connectAttr "skinCluster4GroupId.id" "breakingcrate_mesh4Shape.iog.og[2].gid";
connectAttr "skinCluster4Set.mwc" "breakingcrate_mesh4Shape.iog.og[2].gco";
connectAttr "groupId199.id" "breakingcrate_mesh4Shape.iog.og[3].gid";
connectAttr "tweakSet4.mwc" "breakingcrate_mesh4Shape.iog.og[3].gco";
connectAttr "tweak4.vl[0].vt[0]" "breakingcrate_mesh4Shape.twl";
connectAttr "skinCluster5.og[0]" "breakingcrate_mesh5Shape.i";
connectAttr "groupId200.id" "breakingcrate_mesh5Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh5Shape.iog.og[0].gco";
connectAttr "groupId201.id" "breakingcrate_mesh5Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh5Shape.iog.og[1].gco"
		;
connectAttr "skinCluster5GroupId.id" "breakingcrate_mesh5Shape.iog.og[2].gid";
connectAttr "skinCluster5Set.mwc" "breakingcrate_mesh5Shape.iog.og[2].gco";
connectAttr "groupId203.id" "breakingcrate_mesh5Shape.iog.og[3].gid";
connectAttr "tweakSet5.mwc" "breakingcrate_mesh5Shape.iog.og[3].gco";
connectAttr "tweak5.vl[0].vt[0]" "breakingcrate_mesh5Shape.twl";
connectAttr "skinCluster6.og[0]" "breakingcrate_mesh6Shape.i";
connectAttr "groupId204.id" "breakingcrate_mesh6Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh6Shape.iog.og[0].gco";
connectAttr "groupId205.id" "breakingcrate_mesh6Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh6Shape.iog.og[1].gco"
		;
connectAttr "skinCluster6GroupId.id" "breakingcrate_mesh6Shape.iog.og[2].gid";
connectAttr "skinCluster6Set.mwc" "breakingcrate_mesh6Shape.iog.og[2].gco";
connectAttr "groupId207.id" "breakingcrate_mesh6Shape.iog.og[3].gid";
connectAttr "tweakSet6.mwc" "breakingcrate_mesh6Shape.iog.og[3].gco";
connectAttr "tweak6.vl[0].vt[0]" "breakingcrate_mesh6Shape.twl";
connectAttr "skinCluster7.og[0]" "breakingcrate_mesh7Shape.i";
connectAttr "groupId208.id" "breakingcrate_mesh7Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh7Shape.iog.og[0].gco";
connectAttr "groupId209.id" "breakingcrate_mesh7Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh7Shape.iog.og[1].gco"
		;
connectAttr "skinCluster7GroupId.id" "breakingcrate_mesh7Shape.iog.og[2].gid";
connectAttr "skinCluster7Set.mwc" "breakingcrate_mesh7Shape.iog.og[2].gco";
connectAttr "groupId211.id" "breakingcrate_mesh7Shape.iog.og[3].gid";
connectAttr "tweakSet7.mwc" "breakingcrate_mesh7Shape.iog.og[3].gco";
connectAttr "tweak7.vl[0].vt[0]" "breakingcrate_mesh7Shape.twl";
connectAttr "skinCluster8.og[0]" "breakingcrate_mesh8Shape.i";
connectAttr "groupId212.id" "breakingcrate_mesh8Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh8Shape.iog.og[0].gco";
connectAttr "groupId213.id" "breakingcrate_mesh8Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh8Shape.iog.og[1].gco"
		;
connectAttr "skinCluster8GroupId.id" "breakingcrate_mesh8Shape.iog.og[2].gid";
connectAttr "skinCluster8Set.mwc" "breakingcrate_mesh8Shape.iog.og[2].gco";
connectAttr "groupId215.id" "breakingcrate_mesh8Shape.iog.og[3].gid";
connectAttr "tweakSet8.mwc" "breakingcrate_mesh8Shape.iog.og[3].gco";
connectAttr "tweak8.vl[0].vt[0]" "breakingcrate_mesh8Shape.twl";
connectAttr "skinCluster9.og[0]" "breakingcrate_mesh9Shape.i";
connectAttr "groupId216.id" "breakingcrate_mesh9Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh9Shape.iog.og[0].gco";
connectAttr "groupId217.id" "breakingcrate_mesh9Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh9Shape.iog.og[1].gco"
		;
connectAttr "skinCluster9GroupId.id" "breakingcrate_mesh9Shape.iog.og[2].gid";
connectAttr "skinCluster9Set.mwc" "breakingcrate_mesh9Shape.iog.og[2].gco";
connectAttr "groupId219.id" "breakingcrate_mesh9Shape.iog.og[3].gid";
connectAttr "tweakSet9.mwc" "breakingcrate_mesh9Shape.iog.og[3].gco";
connectAttr "tweak9.vl[0].vt[0]" "breakingcrate_mesh9Shape.twl";
connectAttr "skinCluster10.og[0]" "breakingcrate_mesh10Shape.i";
connectAttr "groupId220.id" "breakingcrate_mesh10Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh10Shape.iog.og[0].gco"
		;
connectAttr "groupId221.id" "breakingcrate_mesh10Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh10Shape.iog.og[1].gco"
		;
connectAttr "skinCluster10GroupId.id" "breakingcrate_mesh10Shape.iog.og[2].gid";
connectAttr "skinCluster10Set.mwc" "breakingcrate_mesh10Shape.iog.og[2].gco";
connectAttr "groupId223.id" "breakingcrate_mesh10Shape.iog.og[3].gid";
connectAttr "tweakSet10.mwc" "breakingcrate_mesh10Shape.iog.og[3].gco";
connectAttr "tweak10.vl[0].vt[0]" "breakingcrate_mesh10Shape.twl";
connectAttr "skinCluster11.og[0]" "breakingcrate_mesh11Shape.i";
connectAttr "groupId224.id" "breakingcrate_mesh11Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh11Shape.iog.og[0].gco"
		;
connectAttr "groupId225.id" "breakingcrate_mesh11Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh11Shape.iog.og[1].gco"
		;
connectAttr "skinCluster11GroupId.id" "breakingcrate_mesh11Shape.iog.og[2].gid";
connectAttr "skinCluster11Set.mwc" "breakingcrate_mesh11Shape.iog.og[2].gco";
connectAttr "groupId227.id" "breakingcrate_mesh11Shape.iog.og[3].gid";
connectAttr "tweakSet11.mwc" "breakingcrate_mesh11Shape.iog.og[3].gco";
connectAttr "tweak11.vl[0].vt[0]" "breakingcrate_mesh11Shape.twl";
connectAttr "skinCluster12.og[0]" "breakingcrate_mesh12Shape.i";
connectAttr "groupId228.id" "breakingcrate_mesh12Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh12Shape.iog.og[0].gco"
		;
connectAttr "groupId229.id" "breakingcrate_mesh12Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh12Shape.iog.og[1].gco"
		;
connectAttr "skinCluster12GroupId.id" "breakingcrate_mesh12Shape.iog.og[2].gid";
connectAttr "skinCluster12Set.mwc" "breakingcrate_mesh12Shape.iog.og[2].gco";
connectAttr "groupId231.id" "breakingcrate_mesh12Shape.iog.og[3].gid";
connectAttr "tweakSet12.mwc" "breakingcrate_mesh12Shape.iog.og[3].gco";
connectAttr "tweak12.vl[0].vt[0]" "breakingcrate_mesh12Shape.twl";
connectAttr "skinCluster13.og[0]" "breakingcrate_mesh13Shape.i";
connectAttr "groupId232.id" "breakingcrate_mesh13Shape.iog.og[0].gid";
connectAttr ":initialShadingGroup.mwc" "breakingcrate_mesh13Shape.iog.og[0].gco"
		;
connectAttr "groupId233.id" "breakingcrate_mesh13Shape.iog.og[1].gid";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.mwc" "breakingcrate_mesh13Shape.iog.og[1].gco"
		;
connectAttr "skinCluster13GroupId.id" "breakingcrate_mesh13Shape.iog.og[2].gid";
connectAttr "skinCluster13Set.mwc" "breakingcrate_mesh13Shape.iog.og[2].gco";
connectAttr "groupId235.id" "breakingcrate_mesh13Shape.iog.og[3].gid";
connectAttr "tweakSet13.mwc" "breakingcrate_mesh13Shape.iog.og[3].gco";
connectAttr "tweak13.vl[0].vt[0]" "breakingcrate_mesh13Shape.twl";
connectAttr "breakingcrate_loc1_parentConstraint1.ctx" "breakingcrate_loc1.tx";
connectAttr "breakingcrate_loc1_parentConstraint1.cty" "breakingcrate_loc1.ty";
connectAttr "breakingcrate_loc1_parentConstraint1.ctz" "breakingcrate_loc1.tz";
connectAttr "breakingcrate_loc1_parentConstraint1.crx" "breakingcrate_loc1.rx";
connectAttr "breakingcrate_loc1_parentConstraint1.cry" "breakingcrate_loc1.ry";
connectAttr "breakingcrate_loc1_parentConstraint1.crz" "breakingcrate_loc1.rz";
connectAttr "breakingcrate_loc1.ro" "breakingcrate_loc1_parentConstraint1.cro";
connectAttr "breakingcrate_loc1.pim" "breakingcrate_loc1_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc1.rp" "breakingcrate_loc1_parentConstraint1.crp";
connectAttr "breakingcrate_loc1.rpt" "breakingcrate_loc1_parentConstraint1.crt";
connectAttr "breakingcrate_physics_grp1.t" "breakingcrate_loc1_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp1.rp" "breakingcrate_loc1_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp1.rpt" "breakingcrate_loc1_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp1.r" "breakingcrate_loc1_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp1.ro" "breakingcrate_loc1_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp1.s" "breakingcrate_loc1_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp1.pm" "breakingcrate_loc1_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc1_parentConstraint1.w0" "breakingcrate_loc1_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc2_parentConstraint1.ctx" "breakingcrate_loc2.tx";
connectAttr "breakingcrate_loc2_parentConstraint1.cty" "breakingcrate_loc2.ty";
connectAttr "breakingcrate_loc2_parentConstraint1.ctz" "breakingcrate_loc2.tz";
connectAttr "breakingcrate_loc2_parentConstraint1.crx" "breakingcrate_loc2.rx";
connectAttr "breakingcrate_loc2_parentConstraint1.cry" "breakingcrate_loc2.ry";
connectAttr "breakingcrate_loc2_parentConstraint1.crz" "breakingcrate_loc2.rz";
connectAttr "breakingcrate_loc2.ro" "breakingcrate_loc2_parentConstraint1.cro";
connectAttr "breakingcrate_loc2.pim" "breakingcrate_loc2_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc2.rp" "breakingcrate_loc2_parentConstraint1.crp";
connectAttr "breakingcrate_loc2.rpt" "breakingcrate_loc2_parentConstraint1.crt";
connectAttr "breakingcrate_physics_grp2.t" "breakingcrate_loc2_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp2.rp" "breakingcrate_loc2_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp2.rpt" "breakingcrate_loc2_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp2.r" "breakingcrate_loc2_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp2.ro" "breakingcrate_loc2_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp2.s" "breakingcrate_loc2_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp2.pm" "breakingcrate_loc2_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc2_parentConstraint1.w0" "breakingcrate_loc2_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc3_parentConstraint1.ctx" "breakingcrate_loc3.tx";
connectAttr "breakingcrate_loc3_parentConstraint1.cty" "breakingcrate_loc3.ty";
connectAttr "breakingcrate_loc3_parentConstraint1.ctz" "breakingcrate_loc3.tz";
connectAttr "breakingcrate_loc3_parentConstraint1.crx" "breakingcrate_loc3.rx";
connectAttr "breakingcrate_loc3_parentConstraint1.cry" "breakingcrate_loc3.ry";
connectAttr "breakingcrate_loc3_parentConstraint1.crz" "breakingcrate_loc3.rz";
connectAttr "breakingcrate_loc3.ro" "breakingcrate_loc3_parentConstraint1.cro";
connectAttr "breakingcrate_loc3.pim" "breakingcrate_loc3_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc3.rp" "breakingcrate_loc3_parentConstraint1.crp";
connectAttr "breakingcrate_loc3.rpt" "breakingcrate_loc3_parentConstraint1.crt";
connectAttr "breakingcrate_physics_grp3.t" "breakingcrate_loc3_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp3.rp" "breakingcrate_loc3_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp3.rpt" "breakingcrate_loc3_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp3.r" "breakingcrate_loc3_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp3.ro" "breakingcrate_loc3_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp3.s" "breakingcrate_loc3_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp3.pm" "breakingcrate_loc3_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc3_parentConstraint1.w0" "breakingcrate_loc3_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc4_parentConstraint1.ctx" "breakingcrate_loc4.tx";
connectAttr "breakingcrate_loc4_parentConstraint1.cty" "breakingcrate_loc4.ty";
connectAttr "breakingcrate_loc4_parentConstraint1.ctz" "breakingcrate_loc4.tz";
connectAttr "breakingcrate_loc4_parentConstraint1.crx" "breakingcrate_loc4.rx";
connectAttr "breakingcrate_loc4_parentConstraint1.cry" "breakingcrate_loc4.ry";
connectAttr "breakingcrate_loc4_parentConstraint1.crz" "breakingcrate_loc4.rz";
connectAttr "breakingcrate_loc4.ro" "breakingcrate_loc4_parentConstraint1.cro";
connectAttr "breakingcrate_loc4.pim" "breakingcrate_loc4_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc4.rp" "breakingcrate_loc4_parentConstraint1.crp";
connectAttr "breakingcrate_loc4.rpt" "breakingcrate_loc4_parentConstraint1.crt";
connectAttr "breakingcrate_physics_grp4.t" "breakingcrate_loc4_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp4.rp" "breakingcrate_loc4_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp4.rpt" "breakingcrate_loc4_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp4.r" "breakingcrate_loc4_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp4.ro" "breakingcrate_loc4_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp4.s" "breakingcrate_loc4_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp4.pm" "breakingcrate_loc4_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc4_parentConstraint1.w0" "breakingcrate_loc4_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc5_parentConstraint1.ctx" "breakingcrate_loc5.tx";
connectAttr "breakingcrate_loc5_parentConstraint1.cty" "breakingcrate_loc5.ty";
connectAttr "breakingcrate_loc5_parentConstraint1.ctz" "breakingcrate_loc5.tz";
connectAttr "breakingcrate_loc5_parentConstraint1.crx" "breakingcrate_loc5.rx";
connectAttr "breakingcrate_loc5_parentConstraint1.cry" "breakingcrate_loc5.ry";
connectAttr "breakingcrate_loc5_parentConstraint1.crz" "breakingcrate_loc5.rz";
connectAttr "breakingcrate_loc5.ro" "breakingcrate_loc5_parentConstraint1.cro";
connectAttr "breakingcrate_loc5.pim" "breakingcrate_loc5_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc5.rp" "breakingcrate_loc5_parentConstraint1.crp";
connectAttr "breakingcrate_loc5.rpt" "breakingcrate_loc5_parentConstraint1.crt";
connectAttr "breakingcrate_physics_grp5.t" "breakingcrate_loc5_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp5.rp" "breakingcrate_loc5_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp5.rpt" "breakingcrate_loc5_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp5.r" "breakingcrate_loc5_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp5.ro" "breakingcrate_loc5_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp5.s" "breakingcrate_loc5_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp5.pm" "breakingcrate_loc5_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc5_parentConstraint1.w0" "breakingcrate_loc5_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc6_parentConstraint1.ctx" "breakingcrate_loc6.tx";
connectAttr "breakingcrate_loc6_parentConstraint1.cty" "breakingcrate_loc6.ty";
connectAttr "breakingcrate_loc6_parentConstraint1.ctz" "breakingcrate_loc6.tz";
connectAttr "breakingcrate_loc6_parentConstraint1.crx" "breakingcrate_loc6.rx";
connectAttr "breakingcrate_loc6_parentConstraint1.cry" "breakingcrate_loc6.ry";
connectAttr "breakingcrate_loc6_parentConstraint1.crz" "breakingcrate_loc6.rz";
connectAttr "breakingcrate_loc6.ro" "breakingcrate_loc6_parentConstraint1.cro";
connectAttr "breakingcrate_loc6.pim" "breakingcrate_loc6_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc6.rp" "breakingcrate_loc6_parentConstraint1.crp";
connectAttr "breakingcrate_loc6.rpt" "breakingcrate_loc6_parentConstraint1.crt";
connectAttr "breakingcrate_physics_grp6.t" "breakingcrate_loc6_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp6.rp" "breakingcrate_loc6_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp6.rpt" "breakingcrate_loc6_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp6.r" "breakingcrate_loc6_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp6.ro" "breakingcrate_loc6_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp6.s" "breakingcrate_loc6_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp6.pm" "breakingcrate_loc6_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc6_parentConstraint1.w0" "breakingcrate_loc6_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc7_parentConstraint1.ctx" "breakingcrate_loc7.tx";
connectAttr "breakingcrate_loc7_parentConstraint1.cty" "breakingcrate_loc7.ty";
connectAttr "breakingcrate_loc7_parentConstraint1.ctz" "breakingcrate_loc7.tz";
connectAttr "breakingcrate_loc7_parentConstraint1.crx" "breakingcrate_loc7.rx";
connectAttr "breakingcrate_loc7_parentConstraint1.cry" "breakingcrate_loc7.ry";
connectAttr "breakingcrate_loc7_parentConstraint1.crz" "breakingcrate_loc7.rz";
connectAttr "breakingcrate_loc7.ro" "breakingcrate_loc7_parentConstraint1.cro";
connectAttr "breakingcrate_loc7.pim" "breakingcrate_loc7_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc7.rp" "breakingcrate_loc7_parentConstraint1.crp";
connectAttr "breakingcrate_loc7.rpt" "breakingcrate_loc7_parentConstraint1.crt";
connectAttr "breakingcrate_physics_grp7.t" "breakingcrate_loc7_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp7.rp" "breakingcrate_loc7_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp7.rpt" "breakingcrate_loc7_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp7.r" "breakingcrate_loc7_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp7.ro" "breakingcrate_loc7_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp7.s" "breakingcrate_loc7_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp7.pm" "breakingcrate_loc7_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc7_parentConstraint1.w0" "breakingcrate_loc7_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc8_parentConstraint1.ctx" "breakingcrate_loc8.tx";
connectAttr "breakingcrate_loc8_parentConstraint1.cty" "breakingcrate_loc8.ty";
connectAttr "breakingcrate_loc8_parentConstraint1.ctz" "breakingcrate_loc8.tz";
connectAttr "breakingcrate_loc8_parentConstraint1.crx" "breakingcrate_loc8.rx";
connectAttr "breakingcrate_loc8_parentConstraint1.cry" "breakingcrate_loc8.ry";
connectAttr "breakingcrate_loc8_parentConstraint1.crz" "breakingcrate_loc8.rz";
connectAttr "breakingcrate_loc8.ro" "breakingcrate_loc8_parentConstraint1.cro";
connectAttr "breakingcrate_loc8.pim" "breakingcrate_loc8_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc8.rp" "breakingcrate_loc8_parentConstraint1.crp";
connectAttr "breakingcrate_loc8.rpt" "breakingcrate_loc8_parentConstraint1.crt";
connectAttr "breakingcrate_physics_grp8.t" "breakingcrate_loc8_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp8.rp" "breakingcrate_loc8_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp8.rpt" "breakingcrate_loc8_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp8.r" "breakingcrate_loc8_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp8.ro" "breakingcrate_loc8_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp8.s" "breakingcrate_loc8_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp8.pm" "breakingcrate_loc8_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc8_parentConstraint1.w0" "breakingcrate_loc8_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc9_parentConstraint1.ctx" "breakingcrate_loc9.tx";
connectAttr "breakingcrate_loc9_parentConstraint1.cty" "breakingcrate_loc9.ty";
connectAttr "breakingcrate_loc9_parentConstraint1.ctz" "breakingcrate_loc9.tz";
connectAttr "breakingcrate_loc9_parentConstraint1.crx" "breakingcrate_loc9.rx";
connectAttr "breakingcrate_loc9_parentConstraint1.cry" "breakingcrate_loc9.ry";
connectAttr "breakingcrate_loc9_parentConstraint1.crz" "breakingcrate_loc9.rz";
connectAttr "breakingcrate_loc9.ro" "breakingcrate_loc9_parentConstraint1.cro";
connectAttr "breakingcrate_loc9.pim" "breakingcrate_loc9_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc9.rp" "breakingcrate_loc9_parentConstraint1.crp";
connectAttr "breakingcrate_loc9.rpt" "breakingcrate_loc9_parentConstraint1.crt";
connectAttr "breakingcrate_physics_grp9.t" "breakingcrate_loc9_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp9.rp" "breakingcrate_loc9_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp9.rpt" "breakingcrate_loc9_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp9.r" "breakingcrate_loc9_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp9.ro" "breakingcrate_loc9_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp9.s" "breakingcrate_loc9_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp9.pm" "breakingcrate_loc9_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc9_parentConstraint1.w0" "breakingcrate_loc9_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc10_parentConstraint1.ctx" "breakingcrate_loc10.tx"
		;
connectAttr "breakingcrate_loc10_parentConstraint1.cty" "breakingcrate_loc10.ty"
		;
connectAttr "breakingcrate_loc10_parentConstraint1.ctz" "breakingcrate_loc10.tz"
		;
connectAttr "breakingcrate_loc10_parentConstraint1.crx" "breakingcrate_loc10.rx"
		;
connectAttr "breakingcrate_loc10_parentConstraint1.cry" "breakingcrate_loc10.ry"
		;
connectAttr "breakingcrate_loc10_parentConstraint1.crz" "breakingcrate_loc10.rz"
		;
connectAttr "breakingcrate_loc10.ro" "breakingcrate_loc10_parentConstraint1.cro"
		;
connectAttr "breakingcrate_loc10.pim" "breakingcrate_loc10_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc10.rp" "breakingcrate_loc10_parentConstraint1.crp"
		;
connectAttr "breakingcrate_loc10.rpt" "breakingcrate_loc10_parentConstraint1.crt"
		;
connectAttr "breakingcrate_physics_grp10.t" "breakingcrate_loc10_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp10.rp" "breakingcrate_loc10_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp10.rpt" "breakingcrate_loc10_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp10.r" "breakingcrate_loc10_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp10.ro" "breakingcrate_loc10_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp10.s" "breakingcrate_loc10_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp10.pm" "breakingcrate_loc10_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc10_parentConstraint1.w0" "breakingcrate_loc10_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc11_parentConstraint1.ctx" "breakingcrate_loc11.tx"
		;
connectAttr "breakingcrate_loc11_parentConstraint1.cty" "breakingcrate_loc11.ty"
		;
connectAttr "breakingcrate_loc11_parentConstraint1.ctz" "breakingcrate_loc11.tz"
		;
connectAttr "breakingcrate_loc11_parentConstraint1.crx" "breakingcrate_loc11.rx"
		;
connectAttr "breakingcrate_loc11_parentConstraint1.cry" "breakingcrate_loc11.ry"
		;
connectAttr "breakingcrate_loc11_parentConstraint1.crz" "breakingcrate_loc11.rz"
		;
connectAttr "breakingcrate_loc11.ro" "breakingcrate_loc11_parentConstraint1.cro"
		;
connectAttr "breakingcrate_loc11.pim" "breakingcrate_loc11_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc11.rp" "breakingcrate_loc11_parentConstraint1.crp"
		;
connectAttr "breakingcrate_loc11.rpt" "breakingcrate_loc11_parentConstraint1.crt"
		;
connectAttr "breakingcrate_physics_grp11.t" "breakingcrate_loc11_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp11.rp" "breakingcrate_loc11_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp11.rpt" "breakingcrate_loc11_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp11.r" "breakingcrate_loc11_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp11.ro" "breakingcrate_loc11_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp11.s" "breakingcrate_loc11_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp11.pm" "breakingcrate_loc11_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc11_parentConstraint1.w0" "breakingcrate_loc11_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc12_parentConstraint1.ctx" "breakingcrate_loc12.tx"
		;
connectAttr "breakingcrate_loc12_parentConstraint1.cty" "breakingcrate_loc12.ty"
		;
connectAttr "breakingcrate_loc12_parentConstraint1.ctz" "breakingcrate_loc12.tz"
		;
connectAttr "breakingcrate_loc12_parentConstraint1.crx" "breakingcrate_loc12.rx"
		;
connectAttr "breakingcrate_loc12_parentConstraint1.cry" "breakingcrate_loc12.ry"
		;
connectAttr "breakingcrate_loc12_parentConstraint1.crz" "breakingcrate_loc12.rz"
		;
connectAttr "breakingcrate_loc12.ro" "breakingcrate_loc12_parentConstraint1.cro"
		;
connectAttr "breakingcrate_loc12.pim" "breakingcrate_loc12_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc12.rp" "breakingcrate_loc12_parentConstraint1.crp"
		;
connectAttr "breakingcrate_loc12.rpt" "breakingcrate_loc12_parentConstraint1.crt"
		;
connectAttr "breakingcrate_physics_grp12.t" "breakingcrate_loc12_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp12.rp" "breakingcrate_loc12_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp12.rpt" "breakingcrate_loc12_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp12.r" "breakingcrate_loc12_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp12.ro" "breakingcrate_loc12_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp12.s" "breakingcrate_loc12_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp12.pm" "breakingcrate_loc12_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc12_parentConstraint1.w0" "breakingcrate_loc12_parentConstraint1.tg[0].tw"
		;
connectAttr "breakingcrate_loc13_parentConstraint1.ctx" "breakingcrate_loc13.tx"
		;
connectAttr "breakingcrate_loc13_parentConstraint1.cty" "breakingcrate_loc13.ty"
		;
connectAttr "breakingcrate_loc13_parentConstraint1.ctz" "breakingcrate_loc13.tz"
		;
connectAttr "breakingcrate_loc13_parentConstraint1.crx" "breakingcrate_loc13.rx"
		;
connectAttr "breakingcrate_loc13_parentConstraint1.cry" "breakingcrate_loc13.ry"
		;
connectAttr "breakingcrate_loc13_parentConstraint1.crz" "breakingcrate_loc13.rz"
		;
connectAttr "breakingcrate_loc13.ro" "breakingcrate_loc13_parentConstraint1.cro"
		;
connectAttr "breakingcrate_loc13.pim" "breakingcrate_loc13_parentConstraint1.cpim"
		;
connectAttr "breakingcrate_loc13.rp" "breakingcrate_loc13_parentConstraint1.crp"
		;
connectAttr "breakingcrate_loc13.rpt" "breakingcrate_loc13_parentConstraint1.crt"
		;
connectAttr "breakingcrate_physics_grp13.t" "breakingcrate_loc13_parentConstraint1.tg[0].tt"
		;
connectAttr "breakingcrate_physics_grp13.rp" "breakingcrate_loc13_parentConstraint1.tg[0].trp"
		;
connectAttr "breakingcrate_physics_grp13.rpt" "breakingcrate_loc13_parentConstraint1.tg[0].trt"
		;
connectAttr "breakingcrate_physics_grp13.r" "breakingcrate_loc13_parentConstraint1.tg[0].tr"
		;
connectAttr "breakingcrate_physics_grp13.ro" "breakingcrate_loc13_parentConstraint1.tg[0].tro"
		;
connectAttr "breakingcrate_physics_grp13.s" "breakingcrate_loc13_parentConstraint1.tg[0].ts"
		;
connectAttr "breakingcrate_physics_grp13.pm" "breakingcrate_loc13_parentConstraint1.tg[0].tpm"
		;
connectAttr "breakingcrate_loc13_parentConstraint1.w0" "breakingcrate_loc13_parentConstraint1.tg[0].tw"
		;
relationship "link" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" "breakingcrate_vmat1:dota2_hero_shaderfxSG.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" "lambert2SG.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" "breakingcrate_vmat1:dota2_hero_shaderfxSG.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" "lambert2SG.message" ":defaultLightSet.message";
connectAttr "layerManager.dli[0]" "defaultLayer.id";
connectAttr "renderLayerManager.rlmi[0]" "defaultRenderLayer.rlid";
connectAttr "breakingcrate_mesh1Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh2Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh3Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh4Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh5Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh6Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh7Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh8Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh9Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh10Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh11Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh12Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "breakingcrate_mesh13Shape.iog.og[1]" "breakingcrate_vmat1:dota2_hero_shaderfxSG.dsm"
		 -na;
connectAttr "groupId185.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId189.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId193.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId197.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId201.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId205.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId209.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId213.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId217.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId221.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId225.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId229.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "groupId233.msg" "breakingcrate_vmat1:dota2_hero_shaderfxSG.gn" -na;
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.msg" "materialInfo3.sg";
connectAttr "file1.oc" "lambert2.c";
connectAttr "lambert2.oc" "lambert2SG.ss";
connectAttr "lambert2SG.msg" "materialInfo4.sg";
connectAttr "lambert2.msg" "materialInfo4.m";
connectAttr "file1.msg" "materialInfo4.t" -na;
connectAttr ":defaultColorMgtGlobals.cme" "file1.cme";
connectAttr ":defaultColorMgtGlobals.cfe" "file1.cmcf";
connectAttr ":defaultColorMgtGlobals.cfp" "file1.cmcp";
connectAttr ":defaultColorMgtGlobals.wsn" "file1.ws";
connectAttr "place2dTexture1.c" "file1.c";
connectAttr "place2dTexture1.tf" "file1.tf";
connectAttr "place2dTexture1.rf" "file1.rf";
connectAttr "place2dTexture1.mu" "file1.mu";
connectAttr "place2dTexture1.mv" "file1.mv";
connectAttr "place2dTexture1.s" "file1.s";
connectAttr "place2dTexture1.wu" "file1.wu";
connectAttr "place2dTexture1.wv" "file1.wv";
connectAttr "place2dTexture1.re" "file1.re";
connectAttr "place2dTexture1.of" "file1.of";
connectAttr "place2dTexture1.r" "file1.ro";
connectAttr "place2dTexture1.n" "file1.n";
connectAttr "place2dTexture1.vt1" "file1.vt1";
connectAttr "place2dTexture1.vt2" "file1.vt2";
connectAttr "place2dTexture1.vt3" "file1.vt3";
connectAttr "place2dTexture1.vc1" "file1.vc1";
connectAttr "place2dTexture1.o" "file1.uv";
connectAttr "place2dTexture1.ofs" "file1.fs";
connectAttr ":initialShadingGroup.msg" "hyperShadePrimaryNodeEditorSavedTabsInfo.tgi[0].ni[0].dn"
		;
connectAttr ":initialParticleSE.msg" "hyperShadePrimaryNodeEditorSavedTabsInfo.tgi[0].ni[1].dn"
		;
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.msg" "hyperShadePrimaryNodeEditorSavedTabsInfo.tgi[0].ni[2].dn"
		;
connectAttr ":lambert1.msg" "hyperShadePrimaryNodeEditorSavedTabsInfo.tgi[0].ni[4].dn"
		;
connectAttr "breakingcrate_vsVmatToTex_ND1.msg" "hyperShadePrimaryNodeEditorSavedTabsInfo.tgi[0].ni[5].dn"
		;
connectAttr "skinCluster1GroupParts.og" "skinCluster1.ip[0].ig";
connectAttr "skinCluster1GroupId.id" "skinCluster1.ip[0].gi";
connectAttr "bindPose1.msg" "skinCluster1.bp";
connectAttr "breakingcrate_joint1.wm" "skinCluster1.ma[0]";
connectAttr "breakingcrate_joint1.liw" "skinCluster1.lw[0]";
connectAttr "breakingcrate_joint1.obcc" "skinCluster1.ifcl[0]";
connectAttr "breakingcrate_mesh1ShapeOrig.w" "groupParts1.ig";
connectAttr "groupId184.id" "groupParts1.gi";
connectAttr "groupParts1.og" "groupParts2.ig";
connectAttr "groupId185.id" "groupParts2.gi";
connectAttr "groupParts4.og" "tweak1.ip[0].ig";
connectAttr "groupId187.id" "tweak1.ip[0].gi";
connectAttr "skinCluster1GroupId.msg" "skinCluster1Set.gn" -na;
connectAttr "breakingcrate_mesh1Shape.iog.og[2]" "skinCluster1Set.dsm" -na;
connectAttr "skinCluster1.msg" "skinCluster1Set.ub[0]";
connectAttr "tweak1.og[0]" "skinCluster1GroupParts.ig";
connectAttr "skinCluster1GroupId.id" "skinCluster1GroupParts.gi";
connectAttr "groupId187.msg" "tweakSet1.gn" -na;
connectAttr "breakingcrate_mesh1Shape.iog.og[3]" "tweakSet1.dsm" -na;
connectAttr "tweak1.msg" "tweakSet1.ub[0]";
connectAttr "groupParts2.og" "groupParts4.ig";
connectAttr "groupId187.id" "groupParts4.gi";
connectAttr "breakingcrate_joints.msg" "bindPose1.m[0]";
connectAttr "breakingcrate_joint1.msg" "bindPose1.m[1]";
connectAttr "bindPose1.w" "bindPose1.p[0]";
connectAttr "bindPose1.m[0]" "bindPose1.p[1]";
connectAttr "breakingcrate_joint1.bps" "bindPose1.wm[1]";
connectAttr "skinCluster2GroupParts.og" "skinCluster2.ip[0].ig";
connectAttr "skinCluster2GroupId.id" "skinCluster2.ip[0].gi";
connectAttr "bindPose2.msg" "skinCluster2.bp";
connectAttr "breakingcrate_joint2.wm" "skinCluster2.ma[0]";
connectAttr "breakingcrate_joint2.liw" "skinCluster2.lw[0]";
connectAttr "breakingcrate_joint2.obcc" "skinCluster2.ifcl[0]";
connectAttr "breakingcrate_mesh2ShapeOrig.w" "groupParts5.ig";
connectAttr "groupId188.id" "groupParts5.gi";
connectAttr "groupParts5.og" "groupParts6.ig";
connectAttr "groupId189.id" "groupParts6.gi";
connectAttr "groupParts8.og" "tweak2.ip[0].ig";
connectAttr "groupId191.id" "tweak2.ip[0].gi";
connectAttr "skinCluster2GroupId.msg" "skinCluster2Set.gn" -na;
connectAttr "breakingcrate_mesh2Shape.iog.og[2]" "skinCluster2Set.dsm" -na;
connectAttr "skinCluster2.msg" "skinCluster2Set.ub[0]";
connectAttr "tweak2.og[0]" "skinCluster2GroupParts.ig";
connectAttr "skinCluster2GroupId.id" "skinCluster2GroupParts.gi";
connectAttr "groupId191.msg" "tweakSet2.gn" -na;
connectAttr "breakingcrate_mesh2Shape.iog.og[3]" "tweakSet2.dsm" -na;
connectAttr "tweak2.msg" "tweakSet2.ub[0]";
connectAttr "groupParts6.og" "groupParts8.ig";
connectAttr "groupId191.id" "groupParts8.gi";
connectAttr "breakingcrate_joints.msg" "bindPose2.m[0]";
connectAttr "breakingcrate_joint2.msg" "bindPose2.m[1]";
connectAttr "bindPose2.w" "bindPose2.p[0]";
connectAttr "bindPose2.m[0]" "bindPose2.p[1]";
connectAttr "skinCluster3GroupParts.og" "skinCluster3.ip[0].ig";
connectAttr "skinCluster3GroupId.id" "skinCluster3.ip[0].gi";
connectAttr "bindPose3.msg" "skinCluster3.bp";
connectAttr "breakingcrate_joint3.wm" "skinCluster3.ma[0]";
connectAttr "breakingcrate_joint3.liw" "skinCluster3.lw[0]";
connectAttr "breakingcrate_joint3.obcc" "skinCluster3.ifcl[0]";
connectAttr "breakingcrate_mesh3ShapeOrig.w" "groupParts9.ig";
connectAttr "groupId192.id" "groupParts9.gi";
connectAttr "groupParts9.og" "groupParts10.ig";
connectAttr "groupId193.id" "groupParts10.gi";
connectAttr "groupParts12.og" "tweak3.ip[0].ig";
connectAttr "groupId195.id" "tweak3.ip[0].gi";
connectAttr "skinCluster3GroupId.msg" "skinCluster3Set.gn" -na;
connectAttr "breakingcrate_mesh3Shape.iog.og[2]" "skinCluster3Set.dsm" -na;
connectAttr "skinCluster3.msg" "skinCluster3Set.ub[0]";
connectAttr "tweak3.og[0]" "skinCluster3GroupParts.ig";
connectAttr "skinCluster3GroupId.id" "skinCluster3GroupParts.gi";
connectAttr "groupId195.msg" "tweakSet3.gn" -na;
connectAttr "breakingcrate_mesh3Shape.iog.og[3]" "tweakSet3.dsm" -na;
connectAttr "tweak3.msg" "tweakSet3.ub[0]";
connectAttr "groupParts10.og" "groupParts12.ig";
connectAttr "groupId195.id" "groupParts12.gi";
connectAttr "breakingcrate_joints.msg" "bindPose3.m[0]";
connectAttr "breakingcrate_joint3.msg" "bindPose3.m[1]";
connectAttr "bindPose3.w" "bindPose3.p[0]";
connectAttr "bindPose3.m[0]" "bindPose3.p[1]";
connectAttr "skinCluster4GroupParts.og" "skinCluster4.ip[0].ig";
connectAttr "skinCluster4GroupId.id" "skinCluster4.ip[0].gi";
connectAttr "bindPose4.msg" "skinCluster4.bp";
connectAttr "breakingcrate_joint4.wm" "skinCluster4.ma[0]";
connectAttr "breakingcrate_joint4.liw" "skinCluster4.lw[0]";
connectAttr "breakingcrate_joint4.obcc" "skinCluster4.ifcl[0]";
connectAttr "breakingcrate_mesh4ShapeOrig.w" "groupParts13.ig";
connectAttr "groupId196.id" "groupParts13.gi";
connectAttr "groupParts13.og" "groupParts14.ig";
connectAttr "groupId197.id" "groupParts14.gi";
connectAttr "groupParts16.og" "tweak4.ip[0].ig";
connectAttr "groupId199.id" "tweak4.ip[0].gi";
connectAttr "skinCluster4GroupId.msg" "skinCluster4Set.gn" -na;
connectAttr "breakingcrate_mesh4Shape.iog.og[2]" "skinCluster4Set.dsm" -na;
connectAttr "skinCluster4.msg" "skinCluster4Set.ub[0]";
connectAttr "tweak4.og[0]" "skinCluster4GroupParts.ig";
connectAttr "skinCluster4GroupId.id" "skinCluster4GroupParts.gi";
connectAttr "groupId199.msg" "tweakSet4.gn" -na;
connectAttr "breakingcrate_mesh4Shape.iog.og[3]" "tweakSet4.dsm" -na;
connectAttr "tweak4.msg" "tweakSet4.ub[0]";
connectAttr "groupParts14.og" "groupParts16.ig";
connectAttr "groupId199.id" "groupParts16.gi";
connectAttr "breakingcrate_joints.msg" "bindPose4.m[0]";
connectAttr "breakingcrate_joint4.msg" "bindPose4.m[1]";
connectAttr "bindPose4.w" "bindPose4.p[0]";
connectAttr "bindPose4.m[0]" "bindPose4.p[1]";
connectAttr "skinCluster5GroupParts.og" "skinCluster5.ip[0].ig";
connectAttr "skinCluster5GroupId.id" "skinCluster5.ip[0].gi";
connectAttr "bindPose5.msg" "skinCluster5.bp";
connectAttr "breakingcrate_joint5.wm" "skinCluster5.ma[0]";
connectAttr "breakingcrate_joint5.liw" "skinCluster5.lw[0]";
connectAttr "breakingcrate_joint5.obcc" "skinCluster5.ifcl[0]";
connectAttr "breakingcrate_mesh5ShapeOrig.w" "groupParts17.ig";
connectAttr "groupId200.id" "groupParts17.gi";
connectAttr "groupParts17.og" "groupParts18.ig";
connectAttr "groupId201.id" "groupParts18.gi";
connectAttr "groupParts20.og" "tweak5.ip[0].ig";
connectAttr "groupId203.id" "tweak5.ip[0].gi";
connectAttr "skinCluster5GroupId.msg" "skinCluster5Set.gn" -na;
connectAttr "breakingcrate_mesh5Shape.iog.og[2]" "skinCluster5Set.dsm" -na;
connectAttr "skinCluster5.msg" "skinCluster5Set.ub[0]";
connectAttr "tweak5.og[0]" "skinCluster5GroupParts.ig";
connectAttr "skinCluster5GroupId.id" "skinCluster5GroupParts.gi";
connectAttr "groupId203.msg" "tweakSet5.gn" -na;
connectAttr "breakingcrate_mesh5Shape.iog.og[3]" "tweakSet5.dsm" -na;
connectAttr "tweak5.msg" "tweakSet5.ub[0]";
connectAttr "groupParts18.og" "groupParts20.ig";
connectAttr "groupId203.id" "groupParts20.gi";
connectAttr "breakingcrate_joints.msg" "bindPose5.m[0]";
connectAttr "breakingcrate_joint5.msg" "bindPose5.m[1]";
connectAttr "bindPose5.w" "bindPose5.p[0]";
connectAttr "bindPose5.m[0]" "bindPose5.p[1]";
connectAttr "skinCluster6GroupParts.og" "skinCluster6.ip[0].ig";
connectAttr "skinCluster6GroupId.id" "skinCluster6.ip[0].gi";
connectAttr "bindPose6.msg" "skinCluster6.bp";
connectAttr "breakingcrate_joint6.wm" "skinCluster6.ma[0]";
connectAttr "breakingcrate_joint6.liw" "skinCluster6.lw[0]";
connectAttr "breakingcrate_joint6.obcc" "skinCluster6.ifcl[0]";
connectAttr "breakingcrate_mesh6ShapeOrig.w" "groupParts21.ig";
connectAttr "groupId204.id" "groupParts21.gi";
connectAttr "groupParts21.og" "groupParts22.ig";
connectAttr "groupId205.id" "groupParts22.gi";
connectAttr "groupParts24.og" "tweak6.ip[0].ig";
connectAttr "groupId207.id" "tweak6.ip[0].gi";
connectAttr "skinCluster6GroupId.msg" "skinCluster6Set.gn" -na;
connectAttr "breakingcrate_mesh6Shape.iog.og[2]" "skinCluster6Set.dsm" -na;
connectAttr "skinCluster6.msg" "skinCluster6Set.ub[0]";
connectAttr "tweak6.og[0]" "skinCluster6GroupParts.ig";
connectAttr "skinCluster6GroupId.id" "skinCluster6GroupParts.gi";
connectAttr "groupId207.msg" "tweakSet6.gn" -na;
connectAttr "breakingcrate_mesh6Shape.iog.og[3]" "tweakSet6.dsm" -na;
connectAttr "tweak6.msg" "tweakSet6.ub[0]";
connectAttr "groupParts22.og" "groupParts24.ig";
connectAttr "groupId207.id" "groupParts24.gi";
connectAttr "breakingcrate_joints.msg" "bindPose6.m[0]";
connectAttr "breakingcrate_joint6.msg" "bindPose6.m[1]";
connectAttr "bindPose6.w" "bindPose6.p[0]";
connectAttr "bindPose6.m[0]" "bindPose6.p[1]";
connectAttr "skinCluster7GroupParts.og" "skinCluster7.ip[0].ig";
connectAttr "skinCluster7GroupId.id" "skinCluster7.ip[0].gi";
connectAttr "bindPose7.msg" "skinCluster7.bp";
connectAttr "breakingcrate_joint7.wm" "skinCluster7.ma[0]";
connectAttr "breakingcrate_joint7.liw" "skinCluster7.lw[0]";
connectAttr "breakingcrate_joint7.obcc" "skinCluster7.ifcl[0]";
connectAttr "breakingcrate_mesh7ShapeOrig.w" "groupParts25.ig";
connectAttr "groupId208.id" "groupParts25.gi";
connectAttr "groupParts25.og" "groupParts26.ig";
connectAttr "groupId209.id" "groupParts26.gi";
connectAttr "groupParts28.og" "tweak7.ip[0].ig";
connectAttr "groupId211.id" "tweak7.ip[0].gi";
connectAttr "skinCluster7GroupId.msg" "skinCluster7Set.gn" -na;
connectAttr "breakingcrate_mesh7Shape.iog.og[2]" "skinCluster7Set.dsm" -na;
connectAttr "skinCluster7.msg" "skinCluster7Set.ub[0]";
connectAttr "tweak7.og[0]" "skinCluster7GroupParts.ig";
connectAttr "skinCluster7GroupId.id" "skinCluster7GroupParts.gi";
connectAttr "groupId211.msg" "tweakSet7.gn" -na;
connectAttr "breakingcrate_mesh7Shape.iog.og[3]" "tweakSet7.dsm" -na;
connectAttr "tweak7.msg" "tweakSet7.ub[0]";
connectAttr "groupParts26.og" "groupParts28.ig";
connectAttr "groupId211.id" "groupParts28.gi";
connectAttr "breakingcrate_joints.msg" "bindPose7.m[0]";
connectAttr "breakingcrate_joint7.msg" "bindPose7.m[1]";
connectAttr "bindPose7.w" "bindPose7.p[0]";
connectAttr "bindPose7.m[0]" "bindPose7.p[1]";
connectAttr "skinCluster8GroupParts.og" "skinCluster8.ip[0].ig";
connectAttr "skinCluster8GroupId.id" "skinCluster8.ip[0].gi";
connectAttr "bindPose8.msg" "skinCluster8.bp";
connectAttr "breakingcrate_joint8.wm" "skinCluster8.ma[0]";
connectAttr "breakingcrate_joint8.liw" "skinCluster8.lw[0]";
connectAttr "breakingcrate_joint8.obcc" "skinCluster8.ifcl[0]";
connectAttr "breakingcrate_mesh8ShapeOrig.w" "groupParts29.ig";
connectAttr "groupId212.id" "groupParts29.gi";
connectAttr "groupParts29.og" "groupParts30.ig";
connectAttr "groupId213.id" "groupParts30.gi";
connectAttr "groupParts32.og" "tweak8.ip[0].ig";
connectAttr "groupId215.id" "tweak8.ip[0].gi";
connectAttr "skinCluster8GroupId.msg" "skinCluster8Set.gn" -na;
connectAttr "breakingcrate_mesh8Shape.iog.og[2]" "skinCluster8Set.dsm" -na;
connectAttr "skinCluster8.msg" "skinCluster8Set.ub[0]";
connectAttr "tweak8.og[0]" "skinCluster8GroupParts.ig";
connectAttr "skinCluster8GroupId.id" "skinCluster8GroupParts.gi";
connectAttr "groupId215.msg" "tweakSet8.gn" -na;
connectAttr "breakingcrate_mesh8Shape.iog.og[3]" "tweakSet8.dsm" -na;
connectAttr "tweak8.msg" "tweakSet8.ub[0]";
connectAttr "groupParts30.og" "groupParts32.ig";
connectAttr "groupId215.id" "groupParts32.gi";
connectAttr "breakingcrate_joints.msg" "bindPose8.m[0]";
connectAttr "breakingcrate_joint8.msg" "bindPose8.m[1]";
connectAttr "bindPose8.w" "bindPose8.p[0]";
connectAttr "bindPose8.m[0]" "bindPose8.p[1]";
connectAttr "skinCluster9GroupParts.og" "skinCluster9.ip[0].ig";
connectAttr "skinCluster9GroupId.id" "skinCluster9.ip[0].gi";
connectAttr "bindPose9.msg" "skinCluster9.bp";
connectAttr "breakingcrate_joint9.wm" "skinCluster9.ma[0]";
connectAttr "breakingcrate_joint9.liw" "skinCluster9.lw[0]";
connectAttr "breakingcrate_joint9.obcc" "skinCluster9.ifcl[0]";
connectAttr "breakingcrate_mesh9ShapeOrig.w" "groupParts33.ig";
connectAttr "groupId216.id" "groupParts33.gi";
connectAttr "groupParts33.og" "groupParts34.ig";
connectAttr "groupId217.id" "groupParts34.gi";
connectAttr "groupParts36.og" "tweak9.ip[0].ig";
connectAttr "groupId219.id" "tweak9.ip[0].gi";
connectAttr "skinCluster9GroupId.msg" "skinCluster9Set.gn" -na;
connectAttr "breakingcrate_mesh9Shape.iog.og[2]" "skinCluster9Set.dsm" -na;
connectAttr "skinCluster9.msg" "skinCluster9Set.ub[0]";
connectAttr "tweak9.og[0]" "skinCluster9GroupParts.ig";
connectAttr "skinCluster9GroupId.id" "skinCluster9GroupParts.gi";
connectAttr "groupId219.msg" "tweakSet9.gn" -na;
connectAttr "breakingcrate_mesh9Shape.iog.og[3]" "tweakSet9.dsm" -na;
connectAttr "tweak9.msg" "tweakSet9.ub[0]";
connectAttr "groupParts34.og" "groupParts36.ig";
connectAttr "groupId219.id" "groupParts36.gi";
connectAttr "breakingcrate_joints.msg" "bindPose9.m[0]";
connectAttr "breakingcrate_joint9.msg" "bindPose9.m[1]";
connectAttr "bindPose9.w" "bindPose9.p[0]";
connectAttr "bindPose9.m[0]" "bindPose9.p[1]";
connectAttr "skinCluster10GroupParts.og" "skinCluster10.ip[0].ig";
connectAttr "skinCluster10GroupId.id" "skinCluster10.ip[0].gi";
connectAttr "bindPose10.msg" "skinCluster10.bp";
connectAttr "breakingcrate_joint10.wm" "skinCluster10.ma[0]";
connectAttr "breakingcrate_joint10.liw" "skinCluster10.lw[0]";
connectAttr "breakingcrate_joint10.obcc" "skinCluster10.ifcl[0]";
connectAttr "breakingcrate_mesh10ShapeOrig.w" "groupParts37.ig";
connectAttr "groupId220.id" "groupParts37.gi";
connectAttr "groupParts37.og" "groupParts38.ig";
connectAttr "groupId221.id" "groupParts38.gi";
connectAttr "groupParts40.og" "tweak10.ip[0].ig";
connectAttr "groupId223.id" "tweak10.ip[0].gi";
connectAttr "skinCluster10GroupId.msg" "skinCluster10Set.gn" -na;
connectAttr "breakingcrate_mesh10Shape.iog.og[2]" "skinCluster10Set.dsm" -na;
connectAttr "skinCluster10.msg" "skinCluster10Set.ub[0]";
connectAttr "tweak10.og[0]" "skinCluster10GroupParts.ig";
connectAttr "skinCluster10GroupId.id" "skinCluster10GroupParts.gi";
connectAttr "groupId223.msg" "tweakSet10.gn" -na;
connectAttr "breakingcrate_mesh10Shape.iog.og[3]" "tweakSet10.dsm" -na;
connectAttr "tweak10.msg" "tweakSet10.ub[0]";
connectAttr "groupParts38.og" "groupParts40.ig";
connectAttr "groupId223.id" "groupParts40.gi";
connectAttr "breakingcrate_joints.msg" "bindPose10.m[0]";
connectAttr "breakingcrate_joint10.msg" "bindPose10.m[1]";
connectAttr "bindPose10.w" "bindPose10.p[0]";
connectAttr "bindPose10.m[0]" "bindPose10.p[1]";
connectAttr "skinCluster11GroupParts.og" "skinCluster11.ip[0].ig";
connectAttr "skinCluster11GroupId.id" "skinCluster11.ip[0].gi";
connectAttr "bindPose11.msg" "skinCluster11.bp";
connectAttr "breakingcrate_joint11.wm" "skinCluster11.ma[0]";
connectAttr "breakingcrate_joint11.liw" "skinCluster11.lw[0]";
connectAttr "breakingcrate_joint11.obcc" "skinCluster11.ifcl[0]";
connectAttr "breakingcrate_mesh11ShapeOrig.w" "groupParts41.ig";
connectAttr "groupId224.id" "groupParts41.gi";
connectAttr "groupParts41.og" "groupParts42.ig";
connectAttr "groupId225.id" "groupParts42.gi";
connectAttr "groupParts44.og" "tweak11.ip[0].ig";
connectAttr "groupId227.id" "tweak11.ip[0].gi";
connectAttr "skinCluster11GroupId.msg" "skinCluster11Set.gn" -na;
connectAttr "breakingcrate_mesh11Shape.iog.og[2]" "skinCluster11Set.dsm" -na;
connectAttr "skinCluster11.msg" "skinCluster11Set.ub[0]";
connectAttr "tweak11.og[0]" "skinCluster11GroupParts.ig";
connectAttr "skinCluster11GroupId.id" "skinCluster11GroupParts.gi";
connectAttr "groupId227.msg" "tweakSet11.gn" -na;
connectAttr "breakingcrate_mesh11Shape.iog.og[3]" "tweakSet11.dsm" -na;
connectAttr "tweak11.msg" "tweakSet11.ub[0]";
connectAttr "groupParts42.og" "groupParts44.ig";
connectAttr "groupId227.id" "groupParts44.gi";
connectAttr "breakingcrate_joints.msg" "bindPose11.m[0]";
connectAttr "breakingcrate_joint11.msg" "bindPose11.m[1]";
connectAttr "bindPose11.w" "bindPose11.p[0]";
connectAttr "bindPose11.m[0]" "bindPose11.p[1]";
connectAttr "skinCluster12GroupParts.og" "skinCluster12.ip[0].ig";
connectAttr "skinCluster12GroupId.id" "skinCluster12.ip[0].gi";
connectAttr "bindPose12.msg" "skinCluster12.bp";
connectAttr "breakingcrate_joint12.wm" "skinCluster12.ma[0]";
connectAttr "breakingcrate_joint12.liw" "skinCluster12.lw[0]";
connectAttr "breakingcrate_joint12.obcc" "skinCluster12.ifcl[0]";
connectAttr "breakingcrate_mesh12ShapeOrig.w" "groupParts45.ig";
connectAttr "groupId228.id" "groupParts45.gi";
connectAttr "groupParts45.og" "groupParts46.ig";
connectAttr "groupId229.id" "groupParts46.gi";
connectAttr "groupParts48.og" "tweak12.ip[0].ig";
connectAttr "groupId231.id" "tweak12.ip[0].gi";
connectAttr "skinCluster12GroupId.msg" "skinCluster12Set.gn" -na;
connectAttr "breakingcrate_mesh12Shape.iog.og[2]" "skinCluster12Set.dsm" -na;
connectAttr "skinCluster12.msg" "skinCluster12Set.ub[0]";
connectAttr "tweak12.og[0]" "skinCluster12GroupParts.ig";
connectAttr "skinCluster12GroupId.id" "skinCluster12GroupParts.gi";
connectAttr "groupId231.msg" "tweakSet12.gn" -na;
connectAttr "breakingcrate_mesh12Shape.iog.og[3]" "tweakSet12.dsm" -na;
connectAttr "tweak12.msg" "tweakSet12.ub[0]";
connectAttr "groupParts46.og" "groupParts48.ig";
connectAttr "groupId231.id" "groupParts48.gi";
connectAttr "breakingcrate_joints.msg" "bindPose12.m[0]";
connectAttr "breakingcrate_joint12.msg" "bindPose12.m[1]";
connectAttr "bindPose12.w" "bindPose12.p[0]";
connectAttr "bindPose12.m[0]" "bindPose12.p[1]";
connectAttr "skinCluster13GroupParts.og" "skinCluster13.ip[0].ig";
connectAttr "skinCluster13GroupId.id" "skinCluster13.ip[0].gi";
connectAttr "bindPose13.msg" "skinCluster13.bp";
connectAttr "breakingcrate_joint13.wm" "skinCluster13.ma[0]";
connectAttr "breakingcrate_joint13.liw" "skinCluster13.lw[0]";
connectAttr "breakingcrate_joint13.obcc" "skinCluster13.ifcl[0]";
connectAttr "breakingcrate_mesh13ShapeOrig.w" "groupParts49.ig";
connectAttr "groupId232.id" "groupParts49.gi";
connectAttr "groupParts49.og" "groupParts50.ig";
connectAttr "groupId233.id" "groupParts50.gi";
connectAttr "groupParts52.og" "tweak13.ip[0].ig";
connectAttr "groupId235.id" "tweak13.ip[0].gi";
connectAttr "skinCluster13GroupId.msg" "skinCluster13Set.gn" -na;
connectAttr "breakingcrate_mesh13Shape.iog.og[2]" "skinCluster13Set.dsm" -na;
connectAttr "skinCluster13.msg" "skinCluster13Set.ub[0]";
connectAttr "tweak13.og[0]" "skinCluster13GroupParts.ig";
connectAttr "skinCluster13GroupId.id" "skinCluster13GroupParts.gi";
connectAttr "groupId235.msg" "tweakSet13.gn" -na;
connectAttr "breakingcrate_mesh13Shape.iog.og[3]" "tweakSet13.dsm" -na;
connectAttr "tweak13.msg" "tweakSet13.ub[0]";
connectAttr "groupParts50.og" "groupParts52.ig";
connectAttr "groupId235.id" "groupParts52.gi";
connectAttr "breakingcrate_joints.msg" "bindPose13.m[0]";
connectAttr "breakingcrate_joint13.msg" "bindPose13.m[1]";
connectAttr "bindPose13.w" "bindPose13.p[0]";
connectAttr "bindPose13.m[0]" "bindPose13.p[1]";
connectAttr "breakingcrate_joint1.msg" "breakingcrate_dest_exportNode.ei[0].objects[0]"
		;
connectAttr "breakingcrate_joint2.msg" "breakingcrate_dest_exportNode.ei[0].objects[1]"
		;
connectAttr "breakingcrate_joint3.msg" "breakingcrate_dest_exportNode.ei[0].objects[2]"
		;
connectAttr "breakingcrate_joint4.msg" "breakingcrate_dest_exportNode.ei[0].objects[3]"
		;
connectAttr "breakingcrate_joint5.msg" "breakingcrate_dest_exportNode.ei[0].objects[4]"
		;
connectAttr "breakingcrate_joint6.msg" "breakingcrate_dest_exportNode.ei[0].objects[5]"
		;
connectAttr "breakingcrate_joint7.msg" "breakingcrate_dest_exportNode.ei[0].objects[6]"
		;
connectAttr "breakingcrate_joint8.msg" "breakingcrate_dest_exportNode.ei[0].objects[7]"
		;
connectAttr "breakingcrate_joint9.msg" "breakingcrate_dest_exportNode.ei[0].objects[8]"
		;
connectAttr "breakingcrate_joint10.msg" "breakingcrate_dest_exportNode.ei[0].objects[9]"
		;
connectAttr "breakingcrate_joint11.msg" "breakingcrate_dest_exportNode.ei[0].objects[10]"
		;
connectAttr "breakingcrate_joint12.msg" "breakingcrate_dest_exportNode.ei[0].objects[11]"
		;
connectAttr "breakingcrate_joint13.msg" "breakingcrate_dest_exportNode.ei[0].objects[12]"
		;
connectAttr "breakingcrate_mesh1.msg" "breakingcrate_dest_exportNode.ei[0].objects[13]"
		;
connectAttr "breakingcrate_mesh2.msg" "breakingcrate_dest_exportNode.ei[0].objects[14]"
		;
connectAttr "breakingcrate_mesh3.msg" "breakingcrate_dest_exportNode.ei[0].objects[15]"
		;
connectAttr "breakingcrate_mesh4.msg" "breakingcrate_dest_exportNode.ei[0].objects[16]"
		;
connectAttr "breakingcrate_mesh5.msg" "breakingcrate_dest_exportNode.ei[0].objects[17]"
		;
connectAttr "breakingcrate_mesh6.msg" "breakingcrate_dest_exportNode.ei[0].objects[18]"
		;
connectAttr "breakingcrate_mesh7.msg" "breakingcrate_dest_exportNode.ei[0].objects[19]"
		;
connectAttr "breakingcrate_mesh8.msg" "breakingcrate_dest_exportNode.ei[0].objects[20]"
		;
connectAttr "breakingcrate_mesh9.msg" "breakingcrate_dest_exportNode.ei[0].objects[21]"
		;
connectAttr "breakingcrate_mesh10.msg" "breakingcrate_dest_exportNode.ei[0].objects[22]"
		;
connectAttr "breakingcrate_mesh11.msg" "breakingcrate_dest_exportNode.ei[0].objects[23]"
		;
connectAttr "breakingcrate_mesh12.msg" "breakingcrate_dest_exportNode.ei[0].objects[24]"
		;
connectAttr "breakingcrate_mesh13.msg" "breakingcrate_dest_exportNode.ei[0].objects[25]"
		;
connectAttr "layerManager.dli[1]" "GEO.id";
connectAttr "layerManager.dli[2]" "JOINTS.id";
connectAttr "breakingcrate_vmat1:dota2_hero_shaderfxSG.pa" ":renderPartition.st"
		 -na;
connectAttr "lambert2SG.pa" ":renderPartition.st" -na;
connectAttr "lambert2.msg" ":defaultShaderList1.s" -na;
connectAttr "breakingcrate_vsVmatToTex_ND1.msg" ":defaultRenderUtilityList1.u" -na
		;
connectAttr "place2dTexture1.msg" ":defaultRenderUtilityList1.u" -na;
connectAttr "defaultRenderLayer.msg" ":defaultRenderingList1.r" -na;
connectAttr ":globalRender.msg" ":defaultRenderingList1.r" -na;
connectAttr "file1.msg" ":defaultTextureList1.tx" -na;
connectAttr "groupId184.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId188.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId192.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId196.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId200.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId204.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId208.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId212.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId216.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId220.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId224.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId228.msg" ":initialShadingGroup.gn" -na;
connectAttr "groupId232.msg" ":initialShadingGroup.gn" -na;
connectAttr "breakingcrate_physics_grp1Shape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo8_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo9_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo10_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo11_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo12_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo13_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo14_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo15_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo16_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo17_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo18_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo19_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo20_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo21_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo22_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo23_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo24_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo25_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo26_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo27_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo28_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo29_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo30_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo31_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo32_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo33_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo34_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo35_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo36_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo37_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo38_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo39_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo40_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo41_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo42_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo43_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo44_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo45_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo46_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo47_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo48_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo49_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo50_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo51_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo52_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo53_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo54_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo55_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo56_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo57_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo58_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo59_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo60_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo61_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo62_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo63_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo64_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo65_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo66_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo67_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo68_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo69_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo70_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo71_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo72_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo73_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo74_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_geo75_physicsShape.iog" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_mesh1Shape.iog.og[0]" ":initialShadingGroup.dsm" -na;
connectAttr "breakingcrate_mesh2Shape.iog.og[0]" ":initialShadingGroup.dsm" -na;
connectAttr "breakingcrate_mesh3Shape.iog.og[0]" ":initialShadingGroup.dsm" -na;
connectAttr "breakingcrate_mesh4Shape.iog.og[0]" ":initialShadingGroup.dsm" -na;
connectAttr "breakingcrate_mesh5Shape.iog.og[0]" ":initialShadingGroup.dsm" -na;
connectAttr "breakingcrate_mesh6Shape.iog.og[0]" ":initialShadingGroup.dsm" -na;
connectAttr "breakingcrate_mesh7Shape.iog.og[0]" ":initialShadingGroup.dsm" -na;
connectAttr "breakingcrate_mesh8Shape.iog.og[0]" ":initialShadingGroup.dsm" -na;
connectAttr "breakingcrate_mesh9Shape.iog.og[0]" ":initialShadingGroup.dsm" -na;
connectAttr "breakingcrate_mesh10Shape.iog.og[0]" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_mesh11Shape.iog.og[0]" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_mesh12Shape.iog.og[0]" ":initialShadingGroup.dsm" -na
		;
connectAttr "breakingcrate_mesh13Shape.iog.og[0]" ":initialShadingGroup.dsm" -na
		;
// End of breakingcrate_dest.ma
