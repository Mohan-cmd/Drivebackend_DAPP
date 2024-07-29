const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports=buildModule("uploadModule",(m)=>{
    const upload = m.contract("Upload");
    return {upload};
})