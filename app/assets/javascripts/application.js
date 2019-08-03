// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).on("click", "#hambugerMenu", function(){
  $('#sideMenu').toggle()
  $('#hambugerMenu').toggle()
});

$(document).on("click", "#closeMenu", function(){
  $('#sideMenu').toggle()
  $('#hambugerMenu').toggle()
});


const isNumericInput = (event) => {
    const key = event.keyCode;
    return ((key >= 48 && key <= 57) || // Allow number line
        (key >= 96 && key <= 105) // Allow number pad
    );
};

const isModifierKey = (event) => {
    const key = event.keyCode;
    return (event.shiftKey === true || key === 35 || key === 36) || // Allow Shift, Home, End
        (key === 8 || key === 9 || key === 13 || key === 46) || // Allow Backspace, Tab, Enter, Delete
        (key > 36 && key < 41) || // Allow left, up, right, down
        (
            // Allow Ctrl/Command + A,C,V,X,Z
            (event.ctrlKey === true || event.metaKey === true) &&
            (key === 65 || key === 67 || key === 86 || key === 88 || key === 90)
        )
};

$(document).on("keyup", "#phoneNumber", function(event){
  if(isModifierKey(event)) {return;}

  // I am lazy and don't like to type things more than once
  const target = event.target;
  const input = target.value.replace(/\D/g,'').substring(0,10); // First ten digits of input only
  const zip = input.substring(0,3);
  const middle = input.substring(3,6);
  const last = input.substring(6,10);

  if(input.length > 6){target.value = `(${zip}) ${middle} - ${last}`;}
  else if(input.length > 3){target.value = `(${zip}) ${middle}`;}
  else if(input.length > 0){target.value = `(${zip}`;}
});

$(document).on("keydown", "#phoneNumber", function(event){
  // Input must be of a valid number format or a modifier key, and not longer than ten digits
  if(!isNumericInput(event) && !isModifierKey(event)){
      event.preventDefault();
  }
});

var removeSplitNav

const resetSplitNav = () => {
  $('.availableSplitContainer').css("display", 'none')
  $('.bookedSplitContainer').css('display', 'none');
  $('.hostSplitContainer').css('display', 'none');
}

$(document).on("click", "#availableNav", function(){
  $('.selectedSplitNavItem').removeClass('selectedSplitNavItem');
  $('#availableNav').addClass('selectedSplitNavItem')
  resetSplitNav()
  $('.availableSplitContainer').css("display", 'block')
});
$(document).on("click", "#bookedNav", function(){
  $('.selectedSplitNavItem').removeClass('selectedSplitNavItem');
  $('#bookedNav').addClass('selectedSplitNavItem')
  resetSplitNav()
  $('.bookedSplitContainer').css("display", 'block')
});
$(document).on("click", "#hostNav", function(){
  $('.selectedSplitNavItem').removeClass('selectedSplitNavItem');
  $('#hostNav').addClass('selectedSplitNavItem')
  resetSplitNav()
  $('.hostSplitContainer').css("display", 'block')
});


// Settings image upload - displays the uploaded image before it is saved to the db
function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        console.log(reader)

        reader.onload = function (e) {
          $('.settingsPhotoLabel').attr('style', 'background: url(' + e.target.result + ') no-repeat center center; background-size: cover;');
        }

        reader.readAsDataURL(input.files[0]);
    }
}

$(document).on("change", ".settingsPhotoInput", function() {
  readURL(this);
})
