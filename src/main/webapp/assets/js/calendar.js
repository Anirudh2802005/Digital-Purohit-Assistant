// =============================================
// Digital Purohit Assistant
// Telugu Calendar
// =============================================

document.addEventListener("DOMContentLoaded", () => {

    initializeTabs();

    initializeCalendar();

});

// =============================================
// Tab Switching
// =============================================

function initializeTabs() {

    const buttons = document.querySelectorAll(".tab-button");

    const panes = document.querySelectorAll(".tab-pane");

    buttons.forEach(button => {

        button.addEventListener("click", function () {

            buttons.forEach(btn => btn.classList.remove("active"));

            panes.forEach(tab => tab.classList.remove("active"));

            button.classList.add("active");

            document
                .getElementById(button.dataset.tab)
                .classList.add("active");

        });

    });

}

// =============================================
// Calendar Date Click
// =============================================

function initializeCalendar() {

    const cards = document.querySelectorAll(".day-card");

    cards.forEach(card => {

        card.addEventListener("click", function (e) {

            e.preventDefault();

            cards.forEach(c => c.classList.remove("selected"));

            card.classList.add("selected");

            const day = card.dataset.day;

            const month = card.dataset.month;

            const year = card.dataset.year;

            loadDayDetails(day, month, year);

        });

    });

}

// =============================================
// Load Selected Date
// =============================================

function loadDayDetails(day, month, year){

    console.log("Selected Date : " + day + "-" + month + "-" + year);

    // Later
    // Fetch Panchang API

    // Fetch Events

    // Fetch Group Events

}