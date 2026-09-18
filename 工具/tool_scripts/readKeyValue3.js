const THREE = require("./three-onlymath.min");
const fs = require("fs");
const path = require("path");
console.log("当前工作目录: ", __dirname);
console.log("modeldata.txt 是否存在: ", fs.existsSync(path.join(__dirname, "modeldata.txt")));

// try {
// 	let modeldata = fs.readFileSync(path.join(__dirname, "modeldata.txt"), { encoding: "utf-8" });
// 	// 执行你的其他操作...
//   } catch (error) {
// 	console.error("读取文件时发生错误:", error.message);
//   }

let modeldata = fs.readFileSync(path.join(__dirname, "modeldata.txt"), { encoding: "utf-8" });
let physdata = fs.readFileSync(path.join(__dirname, "physdata.txt"), { encoding: "utf-8" });

// let modeldata = fs.readFileSync("./modeldata.txt", { encoding: "utf-8" });
// let physdata = fs.readFileSync("./physdata.txt", { encoding: "utf-8" });


function readKeyValue3(modeldata) {
	modeldata = modeldata.replace(/<!-- kv3.*-->/, '').replace(/\t/g, '').replace(/\s+/g, '').replace(/\r\n/g, '');
	// modeldata = modeldata.replace(/\t/g, '').replace(/\r\n/g, '');
	let kvObj = [];
	for (let i = 0; i < modeldata.length; i++) {
		let substr = modeldata[i];
		if (substr === '{') {
			let [obj, newLine] = readTable(i);
			kvObj.push(obj);
			i = newLine;
			continue;
		}
	}
	return kvObj;
	// 读取一对中括号里面的内容
	function readTable(startIndex) {
		let kv = {};
		let key = '';
		let value = '';
		let state = 'NONE';
		for (let i = startIndex; i < modeldata.length; i++) {
			let substr = modeldata[i];
			if (substr === '{' && state === 'NONE') {
				state = 'KEY';
				continue;
			}
			if (substr === '}') {
				return [kv, i];
			}
			if (state === 'KEY') {
				if (substr === '=') {
					state = 'VALUE';
					continue;
				} else {
					key += substr;
					continue;
				}
			}
			if (state === 'VALUE') {
				if (modeldata.substr(i, 5) === "false") {
					kv[key] = "false";
					key = '';
					value = '';
					state = 'KEY';
					i = i + 4;
					continue;
				}
				if (modeldata.substr(i, 4) === "true") {
					kv[key] = "true";
					key = '';
					value = '';
					state = 'KEY';
					i = i + 3;
					continue;
				}
				if (substr === '"') {
					state = 'STRING';
					continue;
				} else if (substr === '{') {
					// 读表
					let [obj, newLine] = readTable(i);
					kv[key] = obj;
					key = '';
					value = '';
					i = newLine;
					state = 'KEY';
					continue;
				} else if (substr === '[') {
					// 读数组
					let [obj, newLine] = readArray(i);
					kv[key] = obj;
					key = '';
					value = '';
					i = newLine;
					state = 'KEY';
					continue;
				} else if (isNumber(substr) === true || substr === '.' || substr === '-') {
					state = 'NUMBER';
				}
			}
			if (state === 'STRING') {
				if (substr === '"') {
					kv[key] = value;
					key = '';
					value = '';
					state = 'KEY';
					continue;
				} else {
					value += substr;
					continue;
				}
			}
			if (state === 'NUMBER') {
				if (isNumber(substr) === true || substr === '.' || substr === '-') {
					value += parseFloat(substr);
					continue;
				} else {
					kv[key] = value;
					key = '';
					value = '';
					i--;
					state = 'KEY';
					continue;
				}
			}
		}
	}
	// 读数组
	function readArray(startIndex) {
		let arr = [];
		let state = 'NONE';
		let value = '';
		for (let i = startIndex; i < modeldata.length; i++) {
			let substr = modeldata[i];
			if ((substr === '[' || substr === ',')) {
				if (state === 'NONE') {
					state = 'VALUE';
					continue;
				}
			}
			if (substr === ']') {
				return [arr, i];
			}
			if (state === 'VALUE') {
				if (substr === '"') {
					state = 'STRING';
					continue;
				} else if (substr === '{') {
					let [obj, newLine] = readTable(i);
					arr.push(obj);
					i = newLine;
					state = 'NONE';
					continue;
				}
				else if (substr === '[') {
					const [_arr, newLine] = readArray(i);
					arr.push(_arr);
					i = newLine;
					state = 'NONE';
					continue;
				}
				else {
					state = 'NUMBER';
				}
			}
			if (state === 'STRING') {
				if (substr === '"') {
					arr.push(value);
					value = '';
					i++;
					state = 'VALUE';
					continue;
				} else {
					value += substr;
					continue;
				}
			}
			if (state === 'NUMBER') {
				if (substr === ',') {
					arr.push(value);
					value = '';
					state = 'VALUE';
					continue;
				} else {
					value += substr;
					continue;
				}
			}
		}
	}
}

function isNumber(s) {
	let reg = /^(-?\d+)(\.\d+)?$/;
	if (reg.test(s)) {
		return true;
	}
	return false;
}

function obj2string(o) {
	var r = [];
	if (typeof o == "string") {
		return "\"" + o.replace(/([\'\"\\])/g, "\\$1").replace(/(\n)/g, "\\n").replace(/(\r)/g, "\\r").replace(/(\t)/g, "\\t") + "\"";
	}
	if (typeof o == "object") {
		if (!o.sort) {
			for (var i in o) {
				r.push(i + ":" + obj2string(o[i]));
			}
			if (!/^\n?function\s*toString\(\)\s*\{\n?\s*\[native code\]\n?\s*\}\n?\s*$/.test(o.toString)) {
				r.push("toString:" + o.toString.toString());
			}
			r = "{" + r.join() + "}";
		} else {
			for (var i = 0; i < o.length; i++) {
				r.push(obj2string(o[i]))
			}
			r = "[" + r.join() + "]";
		}
		return r;
	}
	return o.toString();
}

function print(...a) {
	console.log(...a);
}

function quat2euler(quat) {
	const euler = new THREE.Euler();
	for (let i = 0; i < quat.length; i++) {
		quat[i] = parseFloat(quat[i])
	}
	euler.setFromQuaternion(new THREE.Quaternion(...quat), "ZYX");
	return [
		THREE.Math.radToDeg(euler._y),
		THREE.Math.radToDeg(euler._z),
		THREE.Math.radToDeg(euler._x),
	]
}


function transAttachment(attach) {
	const value = attach["value"];
	let str = "{\n\r";
	str += `\t_class = "Attachment"\n\r`;
	str += `\tname = "${attach["key"]}"\n\r`;
	str += `\tparent_bone = "${value["m_influenceNames"][0]}"\n\r`;
	str += `\trelative_origin = [${value["m_vInfluenceOffsets"][0]}]\n\r`;
	str += `\trelative_angles = [${quat2euler(value["m_vInfluenceRotations"][0])}]\n\r`;
	str += `\tweight = ${value["m_nInfluences"]}\n\r`;
	str += `\tignore_rotation = ${value["m_bIgnoreRotation"]}\n\r`;
	str += "\n\r},"
	return str;
}

function transHitboxSet(hitboxset) {
	const value = hitboxset["value"];
	let str = "{\n\r";
	str += `\t_class = "HitboxSet"\n\r`;
	str += `\tname = "${hitboxset["key"]}"\n\r`;
	str += "\tchildren = \n\r[\n\r";
	for (const hitbox of value["m_HitBoxes"]) {
		str += transHitbox(hitbox);
	}
	str += "]\n\r";
	str += "\n\r},\n\r"
	return str;
}

function transHitbox(hitbox) {
	let str = "{\n\r";
	str += `\t_class = "Hitbox"\n\r`;
	str += `\tparent_bone = "${hitbox["m_sBoneName"]}"\n\r`;
	str += `\tsurface_property = "${hitbox["m_sSurfaceProperty"]}"\n\r`;
	str += `\ttranslation_only = ${hitbox["m_bTranslationOnly"]}\n\r`;
	str += `\tgroup_id = ${hitbox["m_nGroupId"]}\n\r`;
	str += `\thitbox_mins = [${hitbox["m_vMinBounds"]}\n\r]`;
	str += `\thitbox_maxs = [${hitbox["m_vMaxBounds"]}\n\r]`;
	str += "\n\r},\n\r"
	return str;
}


const modelObj = readKeyValue3(modeldata)[0];
print(`{
	_class = "AttachmentList"\n\r
	children = \n\r
	\t[\n\r`)
const kvAttachments = modelObj["m_attachments"];
for (const attach of kvAttachments) {
	print(transAttachment(attach));
}
print(`\t]\n\r
},\n\r`)
const kvHitboxSets = modelObj["m_hitboxsets"];
print(`{
	_class = "HitboxSetList"\n\r
	children = \n\r
	\t[
	`)
for (const hitboxset of kvHitboxSets) {
	print(transHitboxSet(hitboxset))
}
print(`\t]\n\r
},\n\r`)


{
	// 假设你已经有一个保存输出信息的数组
	const outputData = [];

	outputData.push(`{
	_class = "AttachmentList"\n\r
	children = \n\r
		[\n\r`);

	const kvAttachments = modelObj["m_attachments"];
	for (const attach of kvAttachments) {
	outputData.push(transAttachment(attach));
	}

	outputData.push(`    ]\n\r
	},\n\r`);

	const kvHitboxSets = modelObj["m_hitboxsets"];
	outputData.push(`{
	_class = "HitboxSetList"\n\r
	children = \n\r
		[\n\r`);

	for (const hitboxset of kvHitboxSets) {
	outputData.push(transHitboxSet(hitboxset));
	}

	outputData.push(`    ]\n\r
	},\n\r`);

	// 将数组中的信息转换为字符串
	const outputString = outputData.join("\n");

	// 指定保存文件的路径
	const outputPath = path.join(__dirname, "hitbox.txt");

	// 将信息写入文件
	fs.writeFileSync(outputPath, outputString, { encoding: "utf-8" });

	console.log("输出信息已保存到文件:", outputPath);
}


const physObj = readKeyValue3(physdata)[0];
const feModel = physObj["m_pFeModel"];
const ctrlName = feModel["m_CtrlName"];
const capsuleRigids = feModel["m_TaperedCapsuleRigids"]
const sphereRigids = feModel["m_SphereRigids"];


function transClothCapsule(capsule) {
	const name = ctrlName[capsule["nNode"]];
	const ctrls = capsule["vSphere"];
	let str = "{\n\r";
	str += `\t_class = "ClothShapeCapsule"\n\r`;
	str += `\tname = "${name + "_clothCapsule"}"\n\r`;
	str += `\tparent_bone = "${name}"\n\r`;
	str += `\tcloth_collision_layer0 = true\n\r`;
	str += `\tcloth_collision_layer1 = true\n\r`;
	str += `\tcloth_collision_layer2 = true\n\r`;
	str += `\tcloth_collision_layer3 = true\n\r`;
	str += `\tcloth_stickiness = 0.0\n\r`;
	str += `\tcloth_collision_priority = 0\n\r`;
	str += `\tvertex_map = ""\n\r`;
	str += `\tinverted_collision = false\n\r`;
	str += `\tplanarize = false\n\r`;
	str += `\tradius0 = ${ctrls[0][3]}\n\r`;
	str += `\tradius1 = ${ctrls[1][3]}\n\r`;
	str += `\tpoint0 = [${ctrls[0].slice(0, 3)}]\n\r`;
	str += `\tpoint1 = [${ctrls[1].slice(0, 3)}]\n\r`;
	str += "\n\r},\n\r"
	return str;
}
function transClothSphere(sphere) {
	const name = ctrlName[sphere["nNode"]];
	const float4 = sphere["vSphere"];
	let str = "{\n\r";
	str += `\t_class = "ClothShapeSphere"\n\r`;
	str += `\tname = "${name + "_clothSphere"}"\n\r`;
	str += `\tparent_bone = "${name}"\n\r`;
	str += `\tcloth_collision_layer0 = true\n\r`;
	str += `\tcloth_collision_layer1 = true\n\r`;
	str += `\tcloth_collision_layer2 = true\n\r`;
	str += `\tcloth_collision_layer3 = true\n\r`;
	str += `\tcloth_stickiness = 0.0\n\r`;
	str += `\tcloth_collision_priority = 0\n\r`;
	str += `\tvertex_map = ""\n\r`;
	str += `\tinverted_collision = false\n\r`;
	str += `\tplanarize = false\n\r`;
	str += `\tradius = ${float4[3]}\n\r`;
	str += `\tcenter = [${float4.slice(0, 3)}]\n\r`;
	str += "\n\r},\n\r"
	return str;
}

print("/////SoftBody/////")
for (const sphere of sphereRigids) {
	print(transClothSphere(sphere))
}
for (const capsule of capsuleRigids) {
	print(transClothCapsule(capsule))
}

// 假设你已经有一个保存输出信息的数组
const outputData = [];

// 示例：将输出信息添加到数组中
for (const sphere of sphereRigids) {
  outputData.push(transClothSphere(sphere));
}

for (const capsule of capsuleRigids) {
  outputData.push(transClothCapsule(capsule));
}

// 将数组中的信息转换为字符串
const outputString = outputData.join("\n");

// 指定保存文件的路径
const outputPath = path.join(__dirname, "softBody.txt");

// 将信息写入文件
fs.writeFileSync(outputPath, outputString, { encoding: "utf-8" });

console.log("输出信息已保存到文件:", outputPath);


print("=====SoftBody=====")