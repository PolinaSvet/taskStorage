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

//tasksLabels
function tasksLabelsAction(action) {

	var xhr = new XMLHttpRequest();
    xhr.open("POST", "/formTasksLabelsList", true);
    xhr.setRequestHeader("Content-Type", "application/json");  
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4 && xhr.status === 200) {
        document.getElementById("output").innerHTML = xhr.responseText;
      }
    };

    var jsonRequest = {};

    switch(action) {
      case 'select_all_data':
        jsonRequest["id"] = 0;
        break;

      case 'select_filter_data':
        addToJsonIfTrue(jsonRequest, 'id', parseInt(document.getElementById("inputId").value, 0), document.getElementById("checkId").checked);
        addToJsonIfTrue(jsonRequest, 'task_id', getSomeValue(document.getElementById('inputTask')), document.getElementById("checkTask").checked);
        addToJsonIfTrue(jsonRequest, 'label_id', getSomeValue(document.getElementById('inputLabel')), document.getElementById("checkLabel").checked);
        break;
      
      case 'tasksLabels_insert':
        addToJsonIfTrue(jsonRequest, 'task_id', getSomeValue(document.getElementById('inputTask')), true);
        addToJsonIfTrue(jsonRequest, 'label_id', getSomeValue(document.getElementById('inputLabel')), true);
        break;

      case 'tasksLabels_update':
        addToJsonIfTrue(jsonRequest, 'id', parseInt(document.getElementById("inputId").value, 0), true);
        addToJsonIfTrue(jsonRequest, 'task_id', getSomeValue(document.getElementById('inputTask')), true);
        addToJsonIfTrue(jsonRequest, 'label_id', getSomeValue(document.getElementById('inputLabel')), true);
        break;  

      case 'tasksLabels_delete':
        addToJsonIfTrue(jsonRequest, 'id', parseInt(document.getElementById("inputId").value, 0), true);
        break;

      default:
        jsonRequest["id"] = 0;
    }

    if (Object.keys(jsonRequest).length === 0 && jsonRequest.constructor === Object) {
      jsonRequest["id"] = 0;
    }

    console.log(jsonRequest);

    var data = {
      action: action,
      value:  jsonRequest,
    };

    xhr.send(JSON.stringify(data));  
}

function tasksLabelsRowClick(id,task_id,label_id) {
  document.getElementById("inputId").value = id;
  document.getElementById("inputTask").value = task_id;
  document.getElementById("inputLabel").value = label_id;
}

function tasksLabelsСhangeBackgroundColor(element, isMouseOver) {
  if (isMouseOver) {
      element.style.backgroundColor = '#F3F4F6'; 
  } else {
      element.style.backgroundColor = ''; 
  }
}

//tasks
function addToJsonIfTrue(jsonObject, key, value, enablevalue) {
  if (enablevalue) {
    jsonObject[key] = value;
  }
}

function getSomeValue(selectElement) {
  let selectedOption = selectElement.options[selectElement.selectedIndex];
  let someValue = parseInt(selectedOption.getAttribute('data-id'), 0);
  someValue = isNaN(someValue) ? 0 : someValue;
  return someValue;
}

var tasksActionLoadFileContent = "";
function tasksActionLoadFile() {
  const [file] = document.querySelector("input[type=file]").files;
  const reader = new FileReader();

  reader.addEventListener(
    "load",
    () => {
      tasksActionLoadFileContent = reader.result;
    },
    false,
  );

  if (file) {
    reader.readAsText(file);
  }
}

function tasksAction(action) {

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/formTasksList", true);
    xhr.setRequestHeader("Content-Type", "application/json");  
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4 && xhr.status === 200) {
        document.getElementById("output").innerHTML = xhr.responseText;
      }
    };

    var jsonRequest = {};
    var jsonRequestPack = [];

    switch(action) {
      case 'select_all_data':
        jsonRequest["id"] = 0;
        break;

      case 'select_filter_data':
        addToJsonIfTrue(jsonRequest, 'id', parseInt(document.getElementById("inputId").value, 0), document.getElementById("checkId").checked);
        addToJsonIfTrue(jsonRequest, 'author_id', getSomeValue(document.getElementById('inputAuthor')), document.getElementById("checkAuthor").checked);
        addToJsonIfTrue(jsonRequest, 'assigned_id', getSomeValue(document.getElementById('inputAssigned')), document.getElementById("checkAssigned").checked);
        addToJsonIfTrue(jsonRequest, 'label_id', getSomeValue(document.getElementById('inputLabel')), document.getElementById("checkLabel").checked);
        addToJsonIfTrue(jsonRequest, 'finish', (document.getElementById('inputFinish').checked? true : false), document.getElementById("checkFinish").checked);
        addToJsonIfTrue(jsonRequest, 'delay', (document.getElementById('inputDelay').checked? true : false), document.getElementById("checkDelay").checked);
        break;
      
      case 'tasks_insert':
        var seconds_opened = parseInt(new Date(document.getElementById('formDt_opened').value).getTime(),0);
        addToJsonIfTrue(jsonRequest, 'dt_opened', seconds_opened, true);
        var seconds_closed = parseInt(new Date(document.getElementById('formDt_closed').value).getTime(),0);
        addToJsonIfTrue(jsonRequest, 'dt_closed_expect', seconds_closed, true);
        addToJsonIfTrue(jsonRequest, 'author_id', getSomeValue(document.getElementById('formAuthor')), true);
        addToJsonIfTrue(jsonRequest, 'assigned_id', getSomeValue(document.getElementById('formAassigned')), true);
        addToJsonIfTrue(jsonRequest, 'title', document.getElementById('formTitle').value, true);
        addToJsonIfTrue(jsonRequest, 'content', document.getElementById('formContent').value, true);
        break;

      case 'tasks_update':
        addToJsonIfTrue(jsonRequest, 'id', parseInt(document.getElementById("formId").innerText, 0), true);
        var seconds_closed = parseInt(new Date(document.getElementById('formDt_closed').value).getTime(),0);
        addToJsonIfTrue(jsonRequest, 'dt_closed_expect', seconds_closed, true);
        addToJsonIfTrue(jsonRequest, 'author_id', getSomeValue(document.getElementById('formAuthor')), true);
        addToJsonIfTrue(jsonRequest, 'assigned_id', getSomeValue(document.getElementById('formAassigned')), true);
        addToJsonIfTrue(jsonRequest, 'title', document.getElementById('formTitle').value, true);
        addToJsonIfTrue(jsonRequest, 'content', document.getElementById('formContent').value, true);
        addToJsonIfTrue(jsonRequest, 'finish', (document.getElementById('formFinish').checked? true : false), true);
        break;  

      case 'tasks_delete':
        addToJsonIfTrue(jsonRequest, 'id', parseInt(document.getElementById("formId").innerText, 0), true);
        break;
      
      case 'check_delay':
        jsonRequest["id"] = 0;
        break;

      case 'load_pack_data':
        jsonRequestPack = JSON.parse(tasksActionLoadFileContent);
        break;  

      default:
        jsonRequest["id"] = 0;
    }

    if (Object.keys(jsonRequest).length === 0 && jsonRequest.constructor === Object) {
      jsonRequest["id"] = 0;
    }

    var data = {
      action: action,
      value:  jsonRequest,
      valuePack:  jsonRequestPack
    };

    xhr.send(JSON.stringify(data));  
}

function tasksOpenDialog(action, Id, Dt_closed_expect_int, Finish, Author_id, Assigned_id, Title, Content) {
  document.getElementById("dialogForm").style.display = "block";

  switch(action) {
    case 'tasks_insert':
      document.getElementById("formCaption").innerText = "ADD NEW TASK...";
      document.getElementById("formBtAdd").style.display = "block";
      document.getElementById("formBtUpdate").style.display = "none";
      document.getElementById("formBtDelete").style.display = "none";
      document.getElementById("formDivDt_opened").style.display = "block";
      document.getElementById("formDivFinish").style.display = "none";
      break;
    case 'tasks_update':
      document.getElementById("formCaption").innerText = "UPDATE/DELETE TASK № "+Id;
      document.getElementById("formBtAdd").style.display = "none";
      document.getElementById("formBtUpdate").style.display = "block";
      document.getElementById("formBtDelete").style.display = "block";
      document.getElementById("formDivDt_opened").style.display = "none";
      document.getElementById("formDivFinish").style.display = "block";
      document.getElementById("formId").innerText = Id;
      const date = new Date(parseInt(Dt_closed_expect_int,0));
      const formattedDate = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}T${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}:${date.getSeconds().toString().padStart(2, '0')}`;
      document.getElementById("formDt_closed").value = formattedDate;
      document.getElementById("formFinish").checked = (Finish == "true" ? true : false);
      document.getElementById("formAuthor").value = Author_id;
      document.getElementById("formAassigned").value = Assigned_id;
      document.getElementById("formTitle").value = Title;
      document.getElementById("formContent").value = Content;
      break;

  }
 }
 
 function tasksCloseDialog() {
  document.getElementById("dialogForm").style.display = "none";
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







