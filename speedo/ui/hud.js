let lastHealth = 999;
let lastArmour = 999;
let lastHunger = 999;
let lastThirst = 999;
let lastStress = 999;
let lastOxigen = 999;

$(document).ready(function () {
  const tachometer = document.querySelector(".tachometer");
  const tachometerBar = document.querySelector(".tachometerBar");
  const fuel = document.querySelector(".fuel");
  const fuelBar = document.querySelector(".fuelBar");
  const engine = document.querySelector(".engine");
  const nitro = document.querySelector(".nitro");
  const engineBar = document.querySelector(".engineBar");
  const nitroBar = document.querySelector(".nitroBar");
  const progress = document.querySelector(".progress-circle");

  const rTachometer = tachometer.r.baseVal.value;
  const rFuel = fuel.r.baseVal.value;
  const rNitro = nitro.r.baseVal.value;
  const rEngine = engine.r.baseVal.value;
  const cirfProgress = progress.r.baseVal.value * 2 * Math.PI;

  const cirfTachometer = rTachometer * 2 * Math.PI;
  const cirfFuel = rFuel * 2 * Math.PI;
  const cirfNitro = rNitro * 2 * Math.PI;
  const cirfEngine = rEngine * 2 * Math.PI;
  let timeout = undefined;
  let interval = undefined;

  isOnVehicle(false);
  setHealth(50);
  setArmour(0);
  setThirst(50);
  setHunger(50);
  setThirst(50);
  setNitro(0);
  setStress(0);
  setOxigen(0);

  voice(false);
  radio();
  locale();

  window.addEventListener("message", function (event) {
    if (event["data"]["progress"] == true) {
      loadProgress(event["data"]["progressTimer"]);
    }

    if (event["data"]["hud"] !== undefined) {
      if (event["data"]["hud"] == true) {
        $("#display-hud").fadeIn(500);
      } else {
        $("#display-hud").fadeOut(500);
      }
    }

    if (event["data"]["nitro"] !== undefined) {
      if (event["data"]["nitro"] > 0) {
        setNitro(event["data"]["nitro"]);
        $(".nitroBar").css("display","inherit");
        $(".nitro").css("display","inherit");
        $(".nitro-icon").css("display","inherit");
      } else {
        setNitro(0);
        $(".nitroBar").css("display","none");
        $(".nitro").css("display","none");
        $(".nitro-icon").css("display","none");
      }
    } else {
      $(".nitroBar").css("display","none");
      $(".nitro").css("display","none");
      $(".nitro-icon").css("display","none");
    }

    if (event["data"]["movie"] !== undefined) {
      if (event["data"]["movie"] == true) {
        $(".movie").css("display", "flex");
      } else {
        $(".movie").css("display", "none");
      }
    }

    if (event["data"]["hood"] !== undefined) {
      if (event["data"]["hood"] == true) {
        $(".hood").css("display", "flex");
      } else {
        $(".hood").css("display", "none");
      }
    }

    if (event["data"]["screen"] !== undefined) {
      if (event["data"]["screen"]) {
        $(".screen").css("display", "flex");
      } else {
        $(".screen").css("display", "none");
      }
    }

    if (event["data"]["talking"] == 1) {
      voice(true);
      $("#voice>.label").html('Falando');
    } else {
      voice(false);
      $("#voice>.label").html('Desativado');
    }

    if (
      lastHealth !== event["data"]["health"] &&
      event["data"]["health"] !== undefined
    ) {
      lastHealth = event["data"]["health"];
      setHealth(lastHealth);
    }

    if (
      lastArmour !== event["data"]["armour"] &&
      event["data"]["armour"] !== undefined
    ) {
      lastArmour = event["data"]["armour"];
      setArmour(lastArmour);
    }

    if (
      lastStress !== event["data"]["stress"] &&
      event["data"]["stress"] !== undefined
    ) {
      lastStress = event["data"]["stress"];
      setStress(lastStress);
    }

    if (
      lastThirst !== event["data"]["thirst"] &&
      event["data"]["thirst"] !== undefined
    ) {
      lastThirst = event["data"]["thirst"];
      setThirst(lastThirst);
    }

    if (
      lastHunger !== event["data"]["hunger"] &&
      event["data"]["hunger"] !== undefined
    ) {
      lastHunger = event["data"]["hunger"];
      setHunger(lastHunger);
    }

    if (
      lastOxigen !== event["data"]["oxigen"] &&
      event["data"]["oxigen"] !== undefined
    ) {
      lastOxigen = event["data"]["oxigen"];
      setOxigen(lastOxigen);
    } else {
      $(".oxygen-box").css("display", "none");
    }

    if (event["data"]["suit"] == undefined) {
      if ($(".oxygen-box").css("display") === "flex") {
        $(".oxygen-box").css("display", "none");
      }
    } else {
      if ($(".oxygen-box").css("display") === "none") {
        $(".oxygen-box").css("display", "flex");
      }
    }

    if (event["data"]["vehicle"] !== undefined) {
      if (event["data"]["vehicle"] == true) {
        isOnVehicle(true);
        if (event["data"]["showbelt"]) {
          setBelt(event["data"]["seatbelt"]);
        }

        setSpeed(parseInt(event["data"]["speed"]));
        setFuel(parseInt(event["data"]["fuel"]));
        setEngine(event["data"]["engine"]);
        setTachometer(event["data"]["rpm"] / 5);
      } else {
        isOnVehicle(false);
      }
    }

    radio(event["data"]["radio"]);
    locale(`${event["data"]["direction"]} | ${event["data"]["street"]}`)
  });

  function isOnVehicle(vehicle) {
    clearTimeout(timeout);
    if (vehicle) {
      $("#speedometer").removeClass("fadeOutDown");
      $(".vehicle").removeClass("fadeOutDown");
      $(".no-vehicle").removeClass("fadeInUp");

      $("#speedometer").addClass("fadeInUp").css("display", "block");
      $(".vehicle").addClass("fadeInUp").css("display", "block");
      $(".no-vehicle").addClass("fadeOutDown");

      $(".no-vehicle").css("display", "none");
    } else {
      $("#speedometer").removeClass("fadeInUp");
      $("#speedometer").addClass("fadeOutDown");

      $("#speedometer").removeClass("fadeInUp");
      $(".vehicle").removeClass("fadeInUp");
      $(".no-vehicle").removeClass("fadeOutDown");

      $("#speedometer").addClass("fadeOutDown");
      $(".vehicle").addClass("fadeOutDown");
      $(".no-vehicle").addClass("fadeInUp").css("display", "block");
      $(".vehicle").css("display", "none");
      timeout = setTimeout(() => {
        $("#speedometer").css("display", "none");
      }, 200);
    }
  }

  function setBelt(belt) {
    if (belt) {
      $("#belt").css("fill", "#F4E440");
      $("#belt").css("filter", "drop-shadow(0 0 2px rgba(244, 229, 64, 0.4))");
    } else {
      $("#belt").css("fill", "white");
      $("#belt").css("filter", "drop-shadow(0 0 0 transparent)");
    }
  }

  function setThirst(value) {
    $(".life-box.thirst>.life-bar").css("height", `${value}%`);
  }

  function setHunger(value) {
    $(".life-box.hunger>.life-bar").css("height", `${value}%`);
  }

  function setOxigen(value) {
    $(".life-box.oxygen>.life-bar").css("height", `${value}%`);
  }

  function setStress(value) {
    if (value > 0) {
      $(".stress-box").css("display", "flex");
    } else {
      $(".stress-box").css("display", "none");
    }
    $(".life-box.stress>.life-bar").css("height", `${value}%`);
  }

  function locale(locale) {
    if (locale) {
      $("#location").css("display", "flex");
      $("#location").html(`
      <span class="label">${locale}<span>
      `);
    } else {
      $("#location").css("display", "none");
    }
  }

  function radio(radio) {
    if (radio) {
      $("#radio").css("display", "flex");
      $("#radio").html(`
        <span class="label">${radio} MHz<span>`);
    } else {
      $("#radio").css("display", "none");
    }
  }

  function voice(voice) {
    if (voice) {
      $("#voice>.icon").addClass("talking");
    } else {
      $("#voice>.icon").removeClass("talking");
    }
  }


  function loadProgress(timeslamp) {
    let tickPerc = 100;
    let tickTimer = timeslamp / 100;

    setProgress(100);
    clearInterval(interval);
    $(".progress-container").css("display", "flex");

    interval = setInterval(tickFrame, tickTimer);

    function tickFrame() {
      tickPerc--;

      if (tickPerc <= 0) {
        $(".progress-container").css("display", "none");
        setProgress(100);
        clearInterval(interval);
        interval = undefined;
      } else {
        timeslamp = timeslamp - timeslamp / tickPerc;
      }
      setProgress(tickPerc);
    }

    return;
  }

  function setProgress(tickPerc) {
    progress.style.strokeDashoffset = (tickPerc / 100) * cirfProgress;
  }

  function setSpeed(value) {
    let stSpeed = value.toString();
    let stSpeedLength = stSpeed.length;
    let speed = "";
    let bZero = true;

    if (stSpeedLength < 3) {
      stSpeedLength = 3 - stSpeedLength;
      for (i = 0; i < stSpeedLength; i++) {
        stSpeed = 0 + stSpeed;
      }
    }
    for (i = 0; i < stSpeed.length; i++) {
      if (bZero && stSpeed[i] == 0) {
        speed += `<p class="zero">${stSpeed[i]}</p>`;
      } else {
        speed += `<p>${stSpeed[i]}</p>`;
        bZero = false;
      }
    }

    $("#speed").html(speed);
  }

  function setHealth(value) {
    var index = value / 10;
    var opacityIndex = (index - Number(index.toString().split(".")[0])).toFixed(
      2
    );
    index = (index - opacityIndex).toFixed();

    const healthBars = $(".life-health>.bars>.item").toArray().reverse();

    healthBars.forEach((bar, i) => {
      if (value <= 1) {
        $(bar).css("background", `none rgba(0, 0, 0, .5)`);
      } else {
        $(".life-box.health>.life-bar").css("height", `${value}%`);
        if (opacityIndex == 0) {
          if (i < index) {
            $(bar).css(
              "background",
              `linear-gradient(to top right, rgb(153, 17, 17) 0%, rgb(255, 46, 46) 100%)`
            );
          } else if (i >= index) {
            $(bar).css("background", `none rgba(0, 0, 0, .5)`);
          }
        } else {
          if (i == index) {
            $(bar).css(
              "background",
              `linear-gradient(to top right, rgba(153, 17, 17, ${opacityIndex}) 0%, rgba(255, 46, 46, ${opacityIndex}) 100%)`
            );
          } else if (i <= index) {
            $(bar).css(
              "background",
              `linear-gradient(to top right, rgb(153, 17, 17) 0%, rgb(255, 46, 46) 100%)`
            );
          } else if (i >= index) {
            $(bar).css("background", `none rgba(0, 0, 0, .5)`);
          }
        }
      }
    });
  }

  function setArmour(value) {
    var index = value / 10;
    var opacityIndex = (index - Number(index.toString().split(".")[0])).toFixed(
      2
    );
    index = (index - opacityIndex).toFixed();

    const armourBars = $(".life-armour>.bars>.item").toArray().reverse();

    armourBars.forEach((bar, i) => {
      if (value <= 1) {
        $(bar).css("background", `none rgba(0, 0, 0, .5)`);
        $(".life-armour").css("opacity", "0");
        $(".life-box.armour").css("display", "none");
      } else {
        $(".life-armour").css("opacity", "1");
        $(".life-box.armour").css("display", "flex");
        $(".life-box.armour>.life-bar").css("height", `${value}%`);
        if (opacityIndex == 0) {
          if (i < index) {
            $(bar).css(
              "background",
              `linear-gradient(to top right, #23137a 0%, #3e25ca 100%)`
            );
          } else if (i >= index) {
            $(bar).css("background", `none rgba(0, 0, 0, .5)`);
          }
        } else {
          if (i == index) {
            $(bar).css(
              "background",
              `linear-gradient(to top right, rgba(35, 19, 124, ${opacityIndex}) 0%, rgba(62, 37, 202, ${opacityIndex}) 100%)`
            );
          } else if (i <= index) {
            $(bar).css(
              "background",
              `linear-gradient(to top right, rgb(35, 19, 124) 0%, rgb(62, 37, 202) 100%)`
            );
          } else if (i >= index) {
            $(bar).css("background", `none rgba(0, 0, 0, .5)`);
          }
        }
      }
    });
  }

  function setTachometer(value) {
    tachometerBar.style.strokeDashoffset =
      cirfTachometer - ((45 * value) / 100 / 100) * cirfTachometer;
  }

  function setFuel(value) {
    fuelBar.style.strokeDashoffset =
      cirfFuel - ((10 * value) / 100 / 100) * cirfFuel;
  }

  function setNitro(value) {
    nitroBar.style.strokeDashoffset =
      cirfNitro - ((20 * value) / 100 / 100) * cirfNitro;
  }

  function setEngine(value) {
    engineBar.style.strokeDashoffset =
      cirfEngine - ((10 * value) / 100 / 100) * cirfEngine;
  }
});

