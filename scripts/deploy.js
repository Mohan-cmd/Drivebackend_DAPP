// const hre = require('hardhat');


// async function main(){
//     const Upload = await hre.ethers.getContractFactory("Upload");
//     const upload = Upload.deploy();
//      await upload.waitForDeployment();

//     console.log("Library uploaded to:",await upload.getAddress());

// }

// main().catch((error)=>{
//     console.log(error);
//     process.exitCode=1;
// })

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports=buildModule("uploadModule",(m)=>{
    const upload = m.contract("Upload");
    return {upload};
})