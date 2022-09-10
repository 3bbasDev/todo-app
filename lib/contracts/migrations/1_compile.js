const todo=artifacts.require('./todo.sol');

module.exports=function (dep){
    dep.deploy(todo);
}