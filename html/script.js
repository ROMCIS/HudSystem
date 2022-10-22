const sginin    = document.querySelector('.hud .sub>div');
const sginup    = document.querySelector('.hud .sub>div');

sginin.querySelector('.toggleSub').addEventListener('click', _=> {
    if (sginin.style.right === "15px") {
        sginin.style.right = "-45px";
      } else {
        sginin.style.right = "15px";
      }
});


