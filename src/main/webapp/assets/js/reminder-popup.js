// ============================================================
// REMINDER POPUP SYSTEM
// ============================================================

// IMPORTANT:
// contextPath must be declared ONCE in JSP.
// Do NOT declare "const contextPath" again in this file.

let currentReminderId = null;
let currentReminderRedirectUrl = "";
let reminderPopupOpen = false;
let reminderChecking = false;


// ============================================================
// CHECK REMINDER
// ============================================================

function checkReminderPopup() {

    // Prevent multiple requests at the same time
    if (reminderChecking) {
        return;
    }

    // Don't create another popup while one is open
    if (reminderPopupOpen) {
        return;
    }

    reminderChecking = true;

    console.log("=================================");
    console.log("CHECKING REMINDER POPUP");
    console.log("=================================");

    fetch(
        contextPath + "/check-reminder-popup",
        {
            method: "GET",
            cache: "no-cache",
            credentials: "same-origin"
        }
    )

    .then(function(response) {

        console.log(
            "Reminder HTTP Status:",
            response.status
        );

        if (!response.ok) {

            throw new Error(
                "HTTP Error: " + response.status
            );
        }

        return response.text();
    })

    .then(function(text) {

        console.log(
            "Reminder raw response:",
            text
        );

        let data;

        try {

            data = JSON.parse(text);

        }
        catch (error) {

            console.error(
                "Reminder response is not valid JSON:",
                text
            );

            return;
        }

        console.log(
            "Reminder response:",
            data
        );


        // ====================================================
        // NO REMINDER
        // ====================================================

        if (
            !data ||
            data.success !== true
        ) {

            console.log(
                "No unread reminder"
            );

            return;
        }


        // ====================================================
        // VALIDATE NOTIFICATION ID
        // ====================================================

        const notificationId =
            Number(data.notificationId);


        if (
            !Number.isFinite(notificationId) ||
            notificationId <= 0
        ) {

            console.error(
                "Invalid notification ID:",
                data.notificationId
            );

            return;
        }


        // ====================================================
        // SAVE CURRENT REMINDER
        // ====================================================

        currentReminderId =
            notificationId;


        currentReminderRedirectUrl =
            data.redirectUrl || "";


        console.log(
            "Reminder ID:",
            currentReminderId
        );

        console.log(
            "Redirect URL:",
            currentReminderRedirectUrl
        );


        // ====================================================
        // OPEN POPUP
        // ====================================================

        reminderPopupOpen = true;

        showReminderPopup(data);

    })

    .catch(function(error) {

        console.error(
            "Reminder check error:",
            error
        );

    })

    .finally(function() {

        reminderChecking = false;

    });
}


// ============================================================
// SHOW REMINDER POPUP
// ============================================================

function showReminderPopup(data) {

    console.log(
        "================================="
    );

    console.log(
        "SHOWING REMINDER POPUP"
    );

    console.log(
        "Notification ID:",
        data.notificationId
    );

    console.log(
        "Title:",
        data.title
    );

    console.log(
        "Redirect:",
        data.redirectUrl
    );

    console.log(
        "================================="
    );


    // ========================================================
    // REMOVE EXISTING POPUP
    // ========================================================

    const oldPopup =
        document.getElementById(
            "reminderPopupOverlay"
        );


    if (oldPopup) {

        oldPopup.remove();

    }


    // ========================================================
    // OVERLAY
    // ========================================================

    const overlay =
        document.createElement("div");

    overlay.id =
        "reminderPopupOverlay";


    overlay.dataset.notificationId =
        String(data.notificationId);


    // ========================================================
    // POPUP
    // ========================================================

    const popup =
        document.createElement("div");

    popup.id =
        "reminderPopup";


    // ========================================================
    // HEADER
    // ========================================================

    const header =
        document.createElement("div");

    header.className =
        "reminder-popup-header";


    const title =
        document.createElement("div");

    title.className =
        "reminder-popup-title";


    title.textContent =
        "🔔 " +
        (
            data.title ||
            "Reminder"
        );


    header.appendChild(title);


    // ========================================================
    // BODY
    // ========================================================

    const body =
        document.createElement("div");

    body.className =
        "reminder-popup-body";


    const message =
        document.createElement("div");

    message.className =
        "reminder-popup-message";


    message.textContent =
        data.message ||
        "You have a new reminder.";


    body.appendChild(message);


    // ========================================================
    // FOOTER
    // ========================================================

    const footer =
        document.createElement("div");

    footer.className =
        "reminder-popup-footer";


    // ========================================================
    // DISMISS BUTTON
    // ========================================================

    const dismissButton =
        document.createElement("button");

    dismissButton.type =
        "button";

    dismissButton.id =
        "reminderDismissButton";

    dismissButton.className =
        "reminder-popup-dismiss";

    dismissButton.textContent =
        "Dismiss";


    // ========================================================
    // DISMISS CLICK
    // ========================================================

    dismissButton.addEventListener(
        "click",
        function(event) {

            event.preventDefault();

            event.stopPropagation();


            console.log(
                "================================="
            );

            console.log(
                "DISMISS BUTTON CLICKED"
            );

            console.log(
                "Notification ID:",
                currentReminderId
            );

            console.log(
                "================================="
            );


            dismissReminder(false);

        }
    );


    // ========================================================
    // VIEW DETAILS BUTTON
    // ========================================================

    const viewButton =
        document.createElement("button");

    viewButton.type =
        "button";

    viewButton.id =
        "reminderViewButton";

    viewButton.className =
        "reminder-popup-view";

    viewButton.textContent =
        "View Details";


    // ========================================================
    // VIEW DETAILS CLICK
    // ========================================================

    viewButton.addEventListener(
        "click",
        function(event) {

            event.preventDefault();

            event.stopPropagation();


            console.log(
                "================================="
            );

            console.log(
                "VIEW DETAILS BUTTON CLICKED"
            );

            console.log(
                "Notification ID:",
                currentReminderId
            );

            console.log(
                "Redirect URL:",
                currentReminderRedirectUrl
            );

            console.log(
                "================================="
            );


            dismissReminder(true);

        }
    );


    // ========================================================
    // ADD BUTTONS
    // ========================================================

    footer.appendChild(
        dismissButton
    );

    footer.appendChild(
        viewButton
    );


    // ========================================================
    // BUILD POPUP
    // ========================================================

    popup.appendChild(
        header
    );

    popup.appendChild(
        body
    );

    popup.appendChild(
        footer
    );


    overlay.appendChild(
        popup
    );


    // ========================================================
    // ADD POPUP TO PAGE
    // ========================================================

    document.body.appendChild(
        overlay
    );


    // ========================================================
    // IMPORTANT:
    // DO NOT DISABLE PAGE SCROLL
    //
    // We intentionally do NOT use:
    //
    // document.body.style.overflow = "hidden";
    //
    // This prevents the reminder popup from locking
    // scrolling on the entire page.
    // ========================================================

    console.log(
        "Reminder popup created successfully"
    );
}


// ============================================================
// DISMISS / MARK REMINDER AS READ
// ============================================================

function dismissReminder(
    redirectAfterRead
) {

    console.log(
        "================================="
    );

    console.log(
        "dismissReminder() START"
    );

    console.log(
        "Notification ID:",
        currentReminderId
    );

    console.log(
        "Redirect after read:",
        redirectAfterRead
    );

    console.log(
        "================================="
    );


    // ========================================================
    // VALIDATE ID
    // ========================================================

    if (
        currentReminderId === null ||
        currentReminderId === undefined ||
        !Number.isFinite(
            Number(currentReminderId)
        ) ||
        Number(currentReminderId) <= 0
    ) {

        console.error(
            "Invalid notification ID:",
            currentReminderId
        );

        closeReminderPopup();

        return;
    }


    const notificationId =
        Number(currentReminderId);


    // ========================================================
    // SAVE REDIRECT BEFORE RESET
    // ========================================================

    const redirectUrl =
        currentReminderRedirectUrl || "";


    // ========================================================
    // GET BUTTONS
    // ========================================================

    const dismissButton =
        document.getElementById(
            "reminderDismissButton"
        );


    const viewButton =
        document.getElementById(
            "reminderViewButton"
        );


    // ========================================================
    // DISABLE BUTTONS
    // ========================================================

    if (dismissButton) {

        dismissButton.disabled =
            true;

        dismissButton.textContent =
            "Please wait...";

    }


    if (viewButton) {

        viewButton.disabled =
            true;

    }


    // ========================================================
    // REQUEST BODY
    // ========================================================

    const requestBody =
        "notificationId=" +
        encodeURIComponent(
            notificationId
        );


    console.log(
        "Sending mark-read request..."
    );

    console.log(
        "URL:",
        contextPath +
        "/mark-reminder-read"
    );

    console.log(
        "Body:",
        requestBody
    );


    // ========================================================
    // MARK AS READ
    // ========================================================

    fetch(
        contextPath +
        "/mark-reminder-read",
        {
            method: "POST",

            headers: {
                "Content-Type":
                    "application/x-www-form-urlencoded"
            },

            credentials:
                "same-origin",

            body:
                requestBody
        }
    )

    .then(function(response) {

        console.log(
            "Mark-read HTTP status:",
            response.status
        );


        if (!response.ok) {

            throw new Error(
                "HTTP Error: " +
                response.status
            );
        }


        return response.text();

    })

    .then(function(result) {

        console.log(
            "Mark-read server response:",
            result
        );


        const cleanResult =
            result.trim()
                .toLowerCase();


        // ====================================================
        // SUCCESS
        // ====================================================

        if (
            cleanResult === "true"
        ) {

            console.log(
                "================================="
            );

            console.log(
                "REMINDER MARKED AS READ"
            );

            console.log(
                "Notification ID:",
                notificationId
            );

            console.log(
                "================================="
            );


            // =================================================
            // CLOSE POPUP
            // =================================================

            closeReminderPopup();


            // =================================================
            // RESET CURRENT REMINDER
            // =================================================

            currentReminderId =
                null;

            currentReminderRedirectUrl =
                "";


            // =================================================
            // VIEW DETAILS
            // =================================================

            if (
                redirectAfterRead &&
                redirectUrl
            ) {

                console.log(
                    "Navigating to:",
                    redirectUrl
                );


                if (
                    redirectUrl.startsWith("/")
                ) {

                    window.location.href =
                        contextPath +
                        redirectUrl;

                }
                else {

                    window.location.href =
                        redirectUrl;

                }


                return;
            }


            // =================================================
            // DISMISS ONLY
            // =================================================

            console.log(
                "Reminder dismissed successfully"
            );


            return;

        }


        // ====================================================
        // SERVER FAILED
        // ====================================================

        console.error(
            "SERVER FAILED TO MARK REMINDER READ"
        );

        console.error(
            "Server response:",
            result
        );


        enableReminderButtons();

    })

    .catch(function(error) {

        console.error(
            "================================="
        );

        console.error(
            "MARK REMINDER ERROR"
        );

        console.error(
            error
        );

        console.error(
            "================================="
        );


        enableReminderButtons();

    });
}


// ============================================================
// ENABLE BUTTONS AGAIN
// ============================================================

function enableReminderButtons() {

    const dismissButton =
        document.getElementById(
            "reminderDismissButton"
        );


    const viewButton =
        document.getElementById(
            "reminderViewButton"
        );


    if (dismissButton) {

        dismissButton.disabled =
            false;

        dismissButton.textContent =
            "Dismiss";

    }


    if (viewButton) {

        viewButton.disabled =
            false;

    }
}


// ============================================================
// CLOSE POPUP
// ============================================================

function closeReminderPopup() {

    console.log(
        "Closing reminder popup..."
    );


    const overlay =
        document.getElementById(
            "reminderPopupOverlay"
        );


    if (overlay) {

        overlay.remove();

    }


    // ========================================================
    // IMPORTANT:
    // We no longer modify document.body.style.overflow here.
    //
    // The popup never disables page scrolling, so there is
    // nothing that needs to be restored.
    // ========================================================

    reminderPopupOpen =
        false;


    console.log(
        "Reminder popup closed"
    );
}


// ============================================================
// START REMINDER SYSTEM
// ============================================================

function startReminderPopupSystem() {

    console.log(
        "================================="
    );

    console.log(
        "REMINDER POPUP SYSTEM STARTED"
    );

    console.log(
        "================================="
    );


    // ========================================================
    // FIRST CHECK AFTER PAGE LOAD
    // ========================================================

    setTimeout(
        function() {

            checkReminderPopup();

        },
        1000
    );


    // ========================================================
    // CONTINUE CHECKING EVERY 10 SECONDS
    // ========================================================

    setInterval(
        function() {

            checkReminderPopup();

        },
        10000
    );
}


// ============================================================
// PAGE LOAD
// ============================================================

window.addEventListener(
    "load",
    function() {

        startReminderPopupSystem();

    }
);