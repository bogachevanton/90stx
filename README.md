# 90STX.XYZ PLATFORM

### Base contracts

The contracts of the projects **[Megapont](https://www.megapont.com/), [Indigo Project](https://www.projectindigonft.com/)** are taken as a basis and supplemented with the necessary functions.
 
All mint actions of new NFTs occur through interaction with the mint contract.

### VRF

For VRF used [@FriendsFerdinand/random-test/](https://github.com/FriendsFerdinand/random-test/tree/main/contracts) with modification.
 
A set of functions has been added to the contract for jackpot tickets to determine the winner by bytes from the hash of the block (VRF). To select the winner we use the hash of the previous block in the Stacks blockchain or its verifiable random function (VRF). Several bytes of information are taken from the function, these bytes are translated into numbers from 1 to 256, and then we get a random number from 1 to 65536 as a result. Using simple mathematical operations (an integer division with a remainder by the number of participating Tickets), we get the ID of our winning Ticket. With one hash, you can get 32 random numbers, so we will have to repeat the process of selecting winning Tickets several times in each next block. Each function for obtaining numbers will be displayed on the blockchain and available for users to see. All information about the selected Tickets will be stored inside the smart contract
