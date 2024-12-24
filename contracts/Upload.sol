pragma solidity >=0.7.0 < 0.9.0;

contract Upload{

    struct Access{
        address user;
        bool access;
    }

    struct Folder{
        string folderName;   
        string[] files;
    }
    
       mapping(address => Folder[]) folders;
       mapping(address=> mapping(address=>mapping(string=>bool))) ownershipNew;
       

    mapping(address=>string[]) value;   
    mapping(address=>mapping(address=>bool)) ownership;
    mapping(address=>Access[]) accessList;
    mapping(address=>mapping(address=>bool)) previousData;

    function add(address _user,string memory url) external { 
        value[_user].push(url);
    }

    function allow(address user) external{ 
       ownership[msg.sender][user]=true;
       if(previousData[msg.sender][user]){
        for(uint i=0;i<accessList[msg.sender].length;i++){
          if(accessList[msg.sender][i].user==user){
            accessList[msg.sender][i].access=true;
          }
        }
       }else{
        accessList[msg.sender].push(Access(user,true));
        previousData[msg.sender][user]=true;
       }
    }

    function disallow(address user) external{
        ownership[msg.sender][user]=false;
        for(uint i=0;i<accessList[msg.sender].length;i++){
            if(accessList[msg.sender][i].user==user){
                accessList[msg.sender][i].access=false;
            }
        }
    }

    function display(address _user) external view returns(Folder[] memory){
        require(_user == msg.sender || ownership[_user][msg.sender], "You do not have access");
        return folders[_user];
    }

    function shareAccess() public view returns(Access[] memory){
        return accessList[msg.sender];
    }


    function addFileToFolder(string memory folderName,string memory url) external{
        Folder[] storage userFolders = folders[msg.sender];
        bool folderExists= false;

        for(uint i=0; i<userFolders.length;i++){
            if(keccak256(bytes(userFolders[i].folderName))== keccak256(bytes(folderName))){
                 userFolders[i].files.push(url);
                 folderExists =true;
                 break;
            }
        }
        if(! folderExists){
            //Folder memory newFolder;
            Folder storage newFolder = folders[msg.sender].push();
            newFolder.folderName = folderName;
            // folders[msg.sender].push(newFolder);

            // folders[msg.sender][userFolders.length].files.push(url);
            newFolder.files.push(url);
           
        }
    }

    function allowFolderAccess(address user,string memory folderName) external{
        ownershipNew[msg.sender][user][folderName]=true;
    }

    function disallowAccessToFolder(address user,string memory folderName) external{
        ownershipNew[msg.sender][user][folderName]=false;
    }

    function displayFolderFiles(address _user,string memory folderName) external view returns(string[] memory){
       require(_user==msg.sender || ownershipNew[_user][msg.sender][folderName],"you do not have access");
       Folder[] storage userFolders = folders[_user];

       for(uint i=0;i<userFolders.length;i++){
        if(keccak256(bytes(userFolders[i].folderName))== keccak256(bytes(folderName))){
            return userFolders[i].files;
        }
       }
       revert("Folder not found");
    }


    function getAllFolders(address _user) external view returns(Folder[] memory){
        require(_user==msg.sender,"you do  not have access");
        return folders[_user];
    }
    function getSharedFolders(address owner, address requester) external view returns (Folder[] memory) {
    require(owner != requester, "Owner and requester cannot be the same");
    Folder[] storage userFolders = folders[owner];
    uint sharedCount = 0;

    // First, count how many folders are shared
    for (uint i = 0; i < userFolders.length; i++) {
        if (ownershipNew[owner][requester][userFolders[i].folderName]) {
            sharedCount++;
        }
    }

    // Create a dynamic array for the shared folders
    Folder[] memory sharedFolders = new Folder[](sharedCount);
    uint index = 0;

    for (uint i = 0; i < userFolders.length; i++) {
        if (ownershipNew[owner][requester][userFolders[i].folderName]) {
            sharedFolders[index] = userFolders[i];
            index++;
        }
    }

    return sharedFolders;
}

}
