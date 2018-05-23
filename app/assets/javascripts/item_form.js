/**
 * checkFunction
 * Used to display aspects of the item form on editing a device,
 * if a device is in use of part of a research project
 */
window.onload = function checkFunction() {
  var researchBox = document.getElementById("is-research-project");
  var researchShow = document.getElementById("device-research-project");
  var loanBox = document.getElementById("in-use");
  var loanShow = document.getElementById("device-in-use");

  if (researchBox.checked == true) {
    researchShow.style.visibility = "visible";
    researchShow.style.display = "block";
    loanBox.style.visibility =  "hidden";
  } else if (loanBox.checked == true) {
    loanShow.style.visibility = "visible";
    loanShow.style.display = "block";
    researchBox.style.visibility = "hidden"
  } else {
    researchBox.checked = false;
    researchShow.style.visibility = "hidden";
    researchShow.style.display = "none";
    loanBox.checked = false;
    loanShow.style.visibility = "hidden";
    loanShow.style.display = "none";
  }
}

/**
 * researchCheckFunction
 * Used on the item form to display the form options
 * if the device is a research project and also hides
 * form options to do with loaning
 */
function researchCheckFunction() {
  var checkBox = document.getElementById("is-research-project");
  var show = document.getElementById("device-research-project");
  var dontShowCheckBox = document.getElementById("in-use");

  if (checkBox.checked == true) {
    show.style.visibility = "visible";
    show.style.display = "block";
    dontShowCheckBox.style.visibility =  "hidden";
  } else {
    show.style.visibility = "hidden";
    show.style.display = "none";
    dontShowCheckBox.style.visibility =  "visible";
    dontShowCheckBox.checked = false;
  }
}

/**
 * inUseCheckFunction
 * Used on the item form to display the form options
 * if the device is on loan and also hides
 * form options to do with research projects
 */
function inUseCheckFunction() {
  var checkBox = document.getElementById("in-use");
  var show = document.getElementById("device-in-use");
  var dontShowCheckBox = document.getElementById("is-research-project")

  if (checkBox.checked == true) {
    show.style.visibility = "visible";
    show.style.display = "block";
    dontShowCheckBox.style.visibility =  "hidden";
  } else {
    show.style.visibility = "hidden";
    show.style.display = "none";
    dontShowCheckBox.style.visibility =  "visible";
    dontShowCheckBox.checked = false;
  }
}
