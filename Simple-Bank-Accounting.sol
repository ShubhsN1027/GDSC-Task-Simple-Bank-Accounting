// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
    contract SimpleBankAccounting {    //Contract name and folderm name mostly similar hence followed that convention

    uint totalBalance = 0;  //variable of type unsigned integer that keeps track of the contract balance.
//A function to know how much account balance is there in the contract presently.
    function getContractBalance() public view returns(uint){  //This function is public and is accessible by other smart contracts. It is available for calling by any function. Return type is integer again. Modifier is view so only viewing is allowed. This function returns varibale of type int.
        return totalBalance;
    }
    //balances is a mapping from address to unit type. Basically, we are mapping "that value" belonging to the address and storing in balances.
    mapping(address => uint) balances; //Here address is the key type and value is balances whose type is uint. Mapping is basically to get that value at the key.
    mapping(address => uint) depositTimestamps;  //Through these statements, the unique ethereum address and time stamps is asscoaited with the balance of the specific smart contract.
    
    // This function is to  deposit amount into this smart contract 
    //
    function addBalance() public payable returns (bool) {  //the word payable here makes sure that function can send and return money.
        //msg.sender is the user who deposits money. With every deopist, the user balance will be updating
        //Basically this will receive the address of the person who is connecting with the contract. msg.value is a built in function that will give us amount sent to smart contract
        //This amount sent to contract by the sender is being added as the balance right.
        balances[msg.sender] = msg.value;  //The syntax here looks similar to array because the way addresses work is similar to arrays.
        totalBalance = totalBalance + msg.value;  //The most basic calculator function of addition is being used here.
        //Timestamp is also recorded.
        depositTimestamps[msg.sender] = block.timestamp; //Each block in the blockchain includes a timestamp specified as the number of seconds since the Unix epoch. Time values are integers. Solidity smart contracts can access the timestamp of the current block as now or block.
// On successful operation, true is returned. Return type of the above function is bool.
        return true;
    }
    
    function getBalance(address userAddress) public view returns(uint) { //Function that calculates interest on the new deposited value
        uint principal = balances[userAddress]; //To get the balance for the address and store it n varibale principal
        //timeElapsed is basically the time from deposit date of money in the smart contract to the date when the user want to check his balance.
        //The basic calculator function of subtraction has been used here. (Line 31)
        uint timeElapsed = block.timestamp - depositTimestamps[userAddress]; // in seconds. Calculating the timeElapsed essentially to get updated balance. block.timestamp is the time of block (transaction creation).
        //The basic calculator functions of multiplying and dividing has been used here.
        return principal + uint((principal * 4 * timeElapsed) / (100 * 365 * 24 * 60 * 60)); //simple interest of 4%  per year. Also, in solidity, we get timestamps in seconds so converting to years.
    }
    
    function withdraw() public payable returns (bool) { //return type is bool
        address payable withdrawTo = payable(msg.sender);   //address "payable" is used to enable transaction to an address.
        uint amountToTransfer = getBalance(msg.sender); //This is the amount (with interest) that will be transferred to the user. Stored in varibale amountToTransfer.
        balances[msg.sender] = 0;  //It is very important to update the balance before a transfer to prevent duplicacy. An important and stand-alone security feature of bklockchain.
        totalBalance = totalBalance - amountToTransfer;
        (bool sent,) = withdrawTo.call{value: amountToTransfer}(""); //amountToTransfer is now withdrawn.
        require(sent, "transfer failed"); //error function if the transfer is not successful.
        
        return true; //If transcation happens successfully that is withdrawal is successful, then true is returned
    }
    
    function addMoneyToContract() public payable {
        totalBalance += msg.value;
    }

    receive() external payable {  //This function is essential to enable the contract to receive money.
    }
}