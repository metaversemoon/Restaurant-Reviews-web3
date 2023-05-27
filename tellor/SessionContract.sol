// SPDX-License-Identifier: GPL-3.0
pragma solidity ^ 0.8 .0;

contract SessionContract {

    struct Session {
        uint id;
        uint stakingAmountCreator;
        uint stakingAmountPeer;
        string cid;
        string roomId;
        bool completed;
        address creator;
        address peer;
        string time;
    }

    Session[] public sessions;
    uint public nextSessionId = 1;

    struct Bounty {
        uint id;
        uint bountyAmount;
        string cid;
        string roomId;
        uint stakingAmountCreator;
        bool completed;
        address creator;
        address peer;
        string time;
    }

    Bounty[] public bounties;
    uint public nextBountyId = 1;

    function createSession(string memory _cid, string memory _roomId, string memory _time) public payable {
        require(msg.value > 0, "Staking amount must be greater than 0");
        Session memory newSession = Session(nextSessionId, msg.value, 0, _cid, _roomId, false, msg.sender, address(0), _time);
        sessions.push(newSession);
        nextSessionId++;
    }

    function joinSession(uint _sessionId, string memory _time, uint _stakingAmountPeer) public payable {
        require(msg.value == _stakingAmountPeer, "Staking amount must match the required amount");
        Session storage session = sessions[_sessionId - 1];
        require(session.id == _sessionId, "Session not found");
        require(!session.completed, "Session already completed");
        require(session.peer == address(0), "Session already joined");
        session.stakingAmountPeer = _stakingAmountPeer;
        session.peer = msg.sender;
        session.time = _time;
    }

    function searchByInout(input string) public {
        // get the session arr then filter
    }

    function createBounty(uint _bountyAmount, string memory _cid, string memory _roomId, uint _stakingAmountCreator, bool _completed, address _creator, address _peer, string memory _time) public {
        Bounty memory newBounty = Bounty(nextBountyId, _bountyAmount, _cid, _roomId, _stakingAmountCreator, _completed, _creator, _peer, _time);
        bounties.push(newBounty);
        nextBountyId++;
    }

    function upcomingInterviews(address _walletAddress) public view returns(Session[] memory) {
        uint upcomingCount = 0;
        for (uint i = 0; i < sessions.length; i++) {
            Session storage session = sessions[i];
            if (session.peer != address(0) && !session.completed) {
                if (session.creator == _walletAddress || session.peer == _walletAddress) {
                    upcomingCount++;
                }

            }
        }
        Session[] memory upcomingSessions = new Session[](upcomingCount);
        uint j = 0;
        for (uint i = 0; i < sessions.length; i++) {
            Session storage session = sessions[i];
            if (session.peer != address(0) && !session.completed) {
                if (session.creator == _walletAddress || session.peer == _walletAddress) {
                    upcomingSessions[j] = session;
                    j++;
                }
            }
        }
        return upcomingSessions;
    }

    function passInterviews(address _walletAddress) public view returns(Session[] memory) {
        uint passCount = 0;
        for (uint i = 0; i < sessions.length; i++) {
            Session storage session = sessions[i];
            if (session.peer != address(0) && session.completed) {
                if (session.creator == _walletAddress || session.peer == _walletAddress) {
                    passCount++;
                }
            }
        }
        Session[] memory passSessions = new Session[](passCount);
        uint j = 0;
        for (uint i = 0; i < sessions.length; i++) {
            Session storage session = sessions[i];
            if (session.peer != address(0) && session.completed) {
                if (session.creator == _walletAddress || session.peer == _walletAddress) {
                    passSessions[j] = session;
                    j++;
                }
            }

        }
        return passSessions;
    }

    function answerBounty(uint _sessionId, string memory _time) public {
        Session storage session = sessions[_sessionId - 1];
        require(session.id == _sessionId, "Session not found");
        require(!session.completed, "Session already completed");
        // take the session  struct & set it to the _peer same for time
        session.time = _time;
        // completed
        session.completed = true;
    }

    // we need a  markBountyCompleted  this marks the the bounty complete after the user fills out the feedback
    function markBountyCompleted(uint _sessionId) public {
        Bounty storage bounty = bounties[_sessionId - 1];
        require(bounty.id == _sessionId, "Bounty not found");
        require(bounty.completed == false, "Bounty already completed");
        bounty.completed = true;
    }

    // we need a  markSessionCompleted  this marks the the bounty complete after the user fills out the feedback
    function markSessionCompleted(uint _sessionId) public {
        Session storage session = sessions[_sessionId - 1];
        require(session.id == _sessionId, "Bounty not found");
        require(session.completed == false, "Bounty already completed");
        session.completed = true;
    }

    function getAllOpenSessions() public view returns(Session[] memory) {
        uint openSessionsCount = 0;
        for (uint i = 0; i < sessions.length; i++) {
            if (!sessions[i].completed) {
                openSessionsCount++;
            }
        }
        Session[] memory openSessions = new Session[](openSessionsCount);
        uint j = 0;
        for (uint i = 0; i < sessions.length; i++) {
            if (!sessions[i].completed) {
                openSessions[j] = sessions[i];
                j++;
            }
        }
        return openSessions;
    }

    function getAllPassSessions() public view returns(Session[] memory) {
        uint closeSessionsCount = 0;
        for (uint i = 0; i < sessions.length; i++) {
            if (sessions[i].completed) {
                closeSessionsCount++;
            }
        }
        Session[] memory closeSessions = new Session[](closeSessionsCount);
        uint j = 0;
        for (uint i = 0; i < sessions.length; i++) {
            if (sessions[i].completed) {
                closeSessions[j] = sessions[i];
                j++;
            }
        }
        return closeSessions;
    }

    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
