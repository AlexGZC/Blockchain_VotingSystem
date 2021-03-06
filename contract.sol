pragma solidity ^0.4.11;
contract BallotMaster{
    address[] private addressList;
    
    function addBallot(address Ballot)
    {
        addressList.push(Ballot);
    }
    function getBallotAddressList() constant returns
    (address[] ballotAddressList){
        ballotAddressList = addressList;
    }
}
/// @title 투표 및 위임
contract Ballot{

 // 이 선언은 새로운 타잎으로 나중에 쓰인다
 // 한 명의 투표자를 나타낸다
 struct Voter{
     uint weight; // weight은 다른 사람이 위임함에 따라 커진다
     bool voted; // 만약 true라면 이 사람은 이미 투표한 것이다
     address delegate; // 자신의 투표권일 위임한 사람의 주소
     uint vote; // 투표한 제안의 인덱스 값
 }

 // 이 것은 하나의 안건을 나타낸다.
 struct Proposal{
     bytes32 name; // 짧은 이름(32바이트 까지)
     uint voteCount; // 총 누적 득표 수
 }
 
 address public chairperson;

 // 이것은 가능한 주소들이 ‘Voter’ 구조체를 저장할 수 있는 상태 변수를 선언한다.
 mapping(address => Voter) public voters;

 // 동적으로 크기가 조정되는 “Proposal”구조체 선언
 Proposal [ ] public proposals;
bytes32 ballotName;
bytes32[10] bytesArray;
uint[10] intArray;
uint NumberOfProposal;




 // ‘ProposalNames’중 하나를 선택하는 투표를 만든다.
 function Ballot( bytes32 ballotname ){
    chairperson = msg.sender;
    voters[chairperson].weight = 1;
    ballotName = ballotname;
     
 }
    function addProposal(bytes32 proposalName)
    {
        proposals.push(Proposal( {
             name : proposalName,
             voteCount : 0
         }));
         NumberOfProposal++;
         
    }
 /// ‘voter’에게 이 투표에 대한 권한을 부여한다.
 /// 오직 chairperson에 의해서만 호출될 수 있다.
 function giveRightToVote(address voter){
     
     if(voters[voter].voted ){

         throw;
     }
     
     voters[ voter ].voted = false;
     voters[ voter ].weight = 1;
 }

 ///보유하고 있는 투표권을(위임 받은 것 포함)
 ///안건 ‘proposals[proposal].name’에 행사한다.

 function vote(uint proposal){
     Voter sender = voters[msg.sender];
     if (sender.voted)
         throw;
     sender.voted = true;
     sender.vote = proposal;

     // 만약 ‘proposal’이 배열에 존재하지 않는다면
     // 자동으로 예외가 던져지고 모든 실행내용이 원상복구될것이다.
     proposals[proposal].voteCount += sender.weight;
 }

function getArray() constant returns (bytes32[10])
    {
        for(uint i=0;i<proposals.length;i++){
            bytesArray[i]=proposals[i].name;
        }
        return bytesArray;
    }

 function getNumberOfProposal() constant returns (uint number)
    {
        number = NumberOfProposal;
    }
    function getBallotName() constant returns (bytes32 name )
    {
        name = ballotName;
        return name;
    }
    function getArrayNum() constant returns (uint[10])
    {
        for(uint i=0;i<proposals.length;i++){
            intArray[i]=proposals[i].voteCount;
        }
        return intArray;
    }
    
 /// @dev 가장 많은 수를 득표한 안건을 선택한다.
 function winningProposals () constant returns (uint winningProposal) {
     uint winningVoteCount = 0;
     for (uint p = 0; p < proposals.length; p++) {
         if (proposals[p].voteCount > winningVoteCount){
             winningVoteCount = proposals[p].voteCount;
             winningProposal = p;
         }
     }
 }
}
