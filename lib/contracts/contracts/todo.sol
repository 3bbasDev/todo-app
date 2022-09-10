// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract TODO{
    uint256 public tasksCount;

    struct Task {
        uint256 id;
        string title;
        uint256 time;
        bool isDone;
    }


    mapping(uint256 => Task) public tasks;

    constructor() public {
        tasksCount = 0;
    }

    event TaskAdded(uint256 _id);
    event TaskDeleted(uint256 _id);
    event TaskEdited(uint256 _id);
    event TaskIsDone(uint256 _id);

    function addTask(string memory _title,uint256 timeStamp) public {
        tasks[tasksCount] = Task(tasksCount, _title,timeStamp,false);
        emit TaskAdded(tasksCount);
        tasksCount++;
    }

    function deleteTask(uint256 _id) public {
        delete tasks[_id];
        emit TaskDeleted(_id);
        tasksCount--;
    }

    function editTask(uint256 _id,string memory _title) public {
        tasks[_id] = Task(_id, _title, tasks[_id].time,tasks[_id].isDone);
        emit TaskEdited(_id);
    }
    function isDoneTask(uint256 _id,bool _isDone) public {
        
        tasks[_id].isDone=_isDone;
        emit TaskIsDone(tasksCount);
    }
}