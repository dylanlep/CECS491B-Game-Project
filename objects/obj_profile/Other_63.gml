///obj_profile - Async Dialog

var _id = async_load[? "id"];
var _status = async_load[? "status"];

if (variable_global_exists("delete_confirm_id") && _id == global.delete_confirm_id) {
    if (_status) {
        submit_delete();
    }
}
