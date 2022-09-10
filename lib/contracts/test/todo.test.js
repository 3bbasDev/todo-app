const todo=artifacts.require("./todo");
//require('chai').use(require('chai-as-promised')).should()

contract("TODO",([owner,receiver]) =>{

    let dateInAWeek = new Date(); // now
dateInAWeek.setDate(dateInAWeek.getDate() + 7); // add 7 days
const deadline = Math.floor(dateInAWeek.getTime() / 1000); // unix timestamp

    let _countTasks=0;
    let _todo ;
    beforeEach(async ()=>{
            _todo= await todo.new();
        }
    )

    describe("Development",async()=>{
        it("constract notesCount",async ()=>{
            const res = await _todo.tasksCount();
            assert.equal(res,0);
        });
    });


    describe("Task",async()=>{
        it("add task",async()=>{
            await _todo.addTask("first",deadline);
            _countTasks++;
            const notesCount=await _todo.tasksCount();
            assert.equal(notesCount,_countTasks);
        });
        it("edit task",async()=>{
            await _todo.addTask("first",deadline);
            const newTitle="first2";
            await _todo.editTask(web3.utils.toBN(String(_countTasks)),newTitle);

            var res=await _todo.tasks(1);
            assert.equal(res.title,newTitle)
        });

        it("delete task",async()=>{
            await _todo.addTask("first",deadline);
            await _todo.deleteTask(web3.utils.toBN(String(_countTasks)));
            const notesCount=await _todo.tasksCount();
            assert.equal(notesCount,0);
        });

        it("isDone task",async()=>{
            await _todo.addTask("first",deadline);
            await _todo.isDoneTask(web3.utils.toBN(String(_countTasks)),true);
            var res=await _todo.tasks(1);
            assert.equal(res.isDone,true);
        });
    });

    // describe("Edit",async()=>{
    //     it("edit task",async()=>{
            
    //         await _todo.editTask(web3.utils.toBN(String(_countTasks)),"first");
    //         const notesCount=await _todo.notesCount();
    //         assert.equal(notesCount.toString(),_countTasks.toString());
    //     });
    // });

    // describe("Delete",async()=>{
    //     it("delete task",async()=>{
    //         await _todo.deleteTask(_countTasks);
    //         _countTasks--;
    //         const notesCount=await _todo.notesCount();
    //         assert.equal(notesCount=_countTasks);
    //     });
    // });

});