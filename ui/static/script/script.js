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

function usersСhangeBackgroundColor(element, isMouseOver) {
  if (isMouseOver) {
      element.style.backgroundColor = '#F3F4F6'; 
  } else {
      element.style.backgroundColor = ''; 
  }
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

function labelsСhangeBackgroundColor(element, isMouseOver) {
  if (isMouseOver) {
      element.style.backgroundColor = '#F3F4F6'; 
  } else {
      element.style.backgroundColor = ''; 
  }
}

//tasks
function tasksAction(action) {

	var xhr = new XMLHttpRequest();
    xhr.open("POST", "/formTasksList", true);
    xhr.setRequestHeader("Content-Type", "application/json");  
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4 && xhr.status === 200) {
        document.getElementById("output").innerHTML = xhr.responseText;
      }
    };

    var jsonRequest = {
      id:   document.getElementById("inputId").value,
      title:   document.getElementById("inputTitle").value
    }

    var data = {
      action: action,
      value:  jsonRequest,
    };

    xhr.send(JSON.stringify(data));  
}

function tasksRowClick(id) {
  document.getElementById("inputId").value = id;
}

function tasksСhangeBackgroundColor(element, isMouseOver) {
  if (isMouseOver) {
      element.style.backgroundColor = '#F9FAFB'; 
  } else {
      element.style.backgroundColor = ''; 
  }
}







