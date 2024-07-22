//users
function usersAction(action) {

	var xhr = new XMLHttpRequest();
    xhr.open("POST", "/formUsersList", true);
    xhr.setRequestHeader("Content-Type", "application/json");  
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4 && xhr.status === 200) {
        document.getElementById("output").innerHTML = xhr.responseText;
      }
    };

    var jsonRequest = {
      id:   document.getElementById("inputId").value,
      name:   document.getElementById("inputName").value
    }

    var data = {
      action: action,
      value:  jsonRequest,
    };

    xhr.send(JSON.stringify(data));  
}

function usersRowClick(id,name) {
  document.getElementById("inputId").value = id;
  document.getElementById("inputName").value = name;
}

//labels
function labelsAction(action) {

	var xhr = new XMLHttpRequest();
    xhr.open("POST", "/formLabelsList", true);
    xhr.setRequestHeader("Content-Type", "application/json");  
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4 && xhr.status === 200) {
        document.getElementById("output").innerHTML = xhr.responseText;
      }
    };

    var jsonRequest = {
      id:   document.getElementById("inputId").value,
      name:   document.getElementById("inputName").value
    }

    var data = {
      action: action,
      value:  jsonRequest,
    };

    xhr.send(JSON.stringify(data));  
}

function labelsRowClick(id,name) {
  document.getElementById("inputId").value = id;
  document.getElementById("inputName").value = name;
}







