/* =========================================================
   REMINDER SYSTEM
   ========================================================= */


/* =========================================================
   GLOBAL VARIABLES
   ========================================================= */

let reminderQueue = [];

let currentReminder = null;

let reminderCheckRunning = false;

let reminderCheckInterval = null;


/* =========================================================
   CONTEXT PATH
   ========================================================= */

const reminderContextPath =
    typeof contextPath !== "undefined"
        ? contextPath
        : "";


/* =========================================================
   GET ELEMENTS
   ========================================================= */

function getReminderElements() {

    return {

        /* Reminder popup */

        popupOverlay:
            document.getElementById(
                "reminderPopupOverlay"
            ),

        popup:
            document.getElementById(
                "reminderPopup"
            ),

        popupIcon:
            document.getElementById(
                "reminderPopupIcon"
            ),

        popupType:
            document.getElementById(
                "reminderPopupType"
            ),

        popupTitle:
            document.getElementById(
                "reminderPopupTitle"
            ),

        popupMessage:
            document.getElementById(
                "reminderPopupMessage"
            ),

        popupTime:
            document.getElementById(
                "reminderPopupTime"
            ),

        viewButton:
            document.getElementById(
                "reminderViewDetailsBtn"
            ),

        dismissButton:
            document.getElementById(
                "reminderDismissBtn"
            ),


        /* Edit modal */

        editModal:
            document.getElementById(
                "editReminderModal"
            ),

        editId:
            document.getElementById(
                "editReminderId"
            ),

        editName:
            document.getElementById(
                "editReminderName"
            ),

        editTime:
            document.getElementById(
                "editReminderTime"
            ),

        editEnabled:
            document.getElementById(
                "editReminderEnabled"
            )
    };
}


/* =========================================================
   MOVE MODALS TO BODY
   ========================================================= */

function moveReminderElementsToBody() {

    const elements =
        getReminderElements();


    /* -----------------------------------------
       MOVE REMINDER POPUP
       ----------------------------------------- */

    if (
        elements.popupOverlay &&
        elements.popupOverlay.parentElement !==
            document.body
    ) {

        document.body.appendChild(
            elements.popupOverlay
        );

        console.log(
            "Reminder popup moved to body"
        );
    }


    /* -----------------------------------------
       MOVE EDIT MODAL
       ----------------------------------------- */

    if (
        elements.editModal &&
        elements.editModal.parentElement !==
            document.body
    ) {

        document.body.appendChild(
            elements.editModal
        );

        console.log(
            "Edit modal moved to body"
        );
    }
}


/* =========================================================
   PAGE INITIALIZATION
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        console.log(
            "Reminder system initialized"
        );


        moveReminderElementsToBody();


        /*
         * Start checking reminders.
         */

        checkReminders();


        /*
         * Check every 10 seconds.
         */

        reminderCheckInterval =
            setInterval(
                checkReminders,
                10000
            );
    }
);


/* =========================================================
   UPDATE REMINDER STATUS
   ========================================================= */

window.updateReminderStatus =
    function (
        id,
        enabled
    ) {

        console.log(
            "Updating reminder status:",
            id,
            enabled
        );


        fetch(
            reminderContextPath +
            "/update-reminder-status",
            {

                method: "POST",

                headers: {

                    "Content-Type":
                        "application/x-www-form-urlencoded"

                },

                credentials:
                    "same-origin",

                body:
                    "id=" +
                    encodeURIComponent(id) +

                    "&enabled=" +
                    encodeURIComponent(enabled)
            }
        )

        .then(
            function (response) {

                if (!response.ok) {

                    throw new Error(
                        "HTTP " +
                        response.status
                    );
                }

                return response.json();
            }
        )

        .then(
            function (data) {

                console.log(
                    "Status response:",
                    data
                );


                if (
                    data &&
                    data.success
                ) {

                    console.log(
                        "Reminder status updated"
                    );

                } else {

                    alert(
                        data &&
                        data.message
                            ? data.message
                            : "Unable to update reminder."
                    );
                }
            }
        )

        .catch(
            function (error) {

                console.error(
                    "Status update error:",
                    error
                );

                alert(
                    "Server error while updating reminder."
                );
            }
        );
    };


/* =========================================================
   OPEN EDIT REMINDER MODAL
   ========================================================= */

window.openReminderModal =
    function (
        id,
        name,
        time,
        enabled
    ) {

        console.log(
            "Opening reminder modal:",
            id,
            name,
            time,
            enabled
        );


        const elements =
            getReminderElements();


        /* -----------------------------------------
           CHECK MODAL
           ----------------------------------------- */

        if (!elements.editModal) {

            console.error(
                "ERROR: editReminderModal not found."
            );

            return;
        }


        /* -----------------------------------------
           HIDE REMINDER POPUP
           ----------------------------------------- */

        if (
            elements.popupOverlay
        ) {

            elements.popupOverlay.classList.remove(
                "show"
            );

            elements.popupOverlay.style.display =
                "none";
        }


        currentReminder = null;


        /* -----------------------------------------
           MOVE EDIT MODAL TO BODY
           ----------------------------------------- */

        if (
            elements.editModal.parentElement !==
                document.body
        ) {

            document.body.appendChild(
                elements.editModal
            );

            console.log(
                "Edit modal moved to body"
            );
        }


        /* -----------------------------------------
           SET REMINDER ID
           ----------------------------------------- */

        if (elements.editId) {

            elements.editId.value =
                id;
        }


        /* -----------------------------------------
           SET REMINDER NAME
           ----------------------------------------- */

        if (elements.editName) {

            elements.editName.value =
                name || "";
        }


        /* -----------------------------------------
           SET REMINDER TIME
           ----------------------------------------- */

        if (
            elements.editTime &&
            time
        ) {

            let formattedTime =
                String(time);


            /*
             * Convert:
             *
             * 18:00:00
             *
             * to:
             *
             * 18:00
             */

            if (
                formattedTime.length >= 5
            ) {

                formattedTime =
                    formattedTime.substring(
                        0,
                        5
                    );
            }


            elements.editTime.value =
                formattedTime;
        }


        /* -----------------------------------------
           SET ENABLED
           ----------------------------------------- */

        if (
            elements.editEnabled
        ) {

            elements.editEnabled.checked =
                Boolean(enabled);
        }


        /* -----------------------------------------
           SHOW MODAL
           ----------------------------------------- */

        elements.editModal.classList.add(
            "show"
        );


        /*
         * Force the correct display.
         */

        elements.editModal.style.display =
            "flex";


        elements.editModal.style.position =
            "fixed";


        elements.editModal.style.top =
            "0";


        elements.editModal.style.left =
            "0";


        elements.editModal.style.width =
            "100vw";


        elements.editModal.style.height =
            "100vh";


        elements.editModal.style.zIndex =
            "2147483646";


        /*
         * Prevent background scrolling.
         */

        document.body.style.overflow =
            "hidden";


        console.log(
            "Reminder modal opened"
        );
    };


/* =========================================================
   CLOSE EDIT REMINDER MODAL
   ========================================================= */

window.closeReminderModal =
    function () {

        const elements =
            getReminderElements();


        if (
            !elements.editModal
        ) {

            return;
        }


        elements.editModal.classList.remove(
            "show"
        );


        elements.editModal.style.display =
            "none";


        elements.editModal.style.position =
            "fixed";


        document.body.style.overflow =
            "";


        console.log(
            "Reminder modal closed"
        );
    };


/* =========================================================
   SAVE REMINDER
   ========================================================= */

window.saveReminder =
    function () {

        const elements =
            getReminderElements();


        const id =
            elements.editId
                ? elements.editId.value
                : "";


        const time =
            elements.editTime
                ? elements.editTime.value
                : "";


        const enabled =
            elements.editEnabled
                ? elements.editEnabled.checked
                : false;


        /* -----------------------------------------
           VALIDATION
           ----------------------------------------- */

        if (!id) {

            alert(
                "Reminder ID is missing."
            );

            return;
        }


        if (!time) {

            alert(
                "Please select a reminder time."
            );

            return;
        }


        console.log(
            "Saving reminder:",
            id,
            time,
            enabled
        );


        /* -----------------------------------------
           DISABLE SAVE BUTTON
           ----------------------------------------- */

        const saveButton =
            document.querySelector(
                "#editReminderModal .save-btn"
            );


        if (saveButton) {

            saveButton.disabled =
                true;
        }


        /* -----------------------------------------
           UPDATE SERVER
           ----------------------------------------- */

        fetch(
            reminderContextPath +
            "/update-reminder",
            {

                method: "POST",

                headers: {

                    "Content-Type":
                        "application/x-www-form-urlencoded"

                },

                credentials:
                    "same-origin",

                body:
                    "id=" +
                    encodeURIComponent(id) +

                    "&time=" +
                    encodeURIComponent(
                        time + ":00"
                    ) +

                    "&enabled=" +
                    encodeURIComponent(
                        enabled
                    )
            }
        )

        .then(
            function (response) {

                if (!response.ok) {

                    throw new Error(
                        "HTTP " +
                        response.status
                    );
                }


                return response.json();
            }
        )

        .then(
            function (data) {

                console.log(
                    "Save reminder response:",
                    data
                );


                if (
                    data &&
                    data.success
                ) {

                    window.closeReminderModal();


                    alert(
                        "Reminder Updated Successfully"
                    );


                    /*
                     * Reload page so the
                     * updated time/status
                     * appears immediately.
                     */

                    window.location.reload();

                } else {

                    alert(
                        data &&
                        data.message
                            ? data.message
                            : "Unable to update reminder."
                    );
                }
            }
        )

        .catch(
            function (error) {

                console.error(
                    "Save reminder error:",
                    error
                );


                alert(
                    "Server error while updating reminder."
                );
            }
        )

        .finally(
            function () {

                if (saveButton) {

                    saveButton.disabled =
                        false;
                }
            }
        );
    };


/* =========================================================
   CHECK REMINDERS
   ========================================================= */
   /* =========================================================
      CHECK REMINDERS
      ========================================================= */

   function checkReminders() {

       /*
        * Don't run two checks simultaneously.
        */

       if (reminderCheckRunning) {
           return;
       }


       var elements =
           getReminderElements();


       /*
        * If Edit modal is open,
        * don't show reminder popup.
        */

       if (
           elements.editModal &&
           elements.editModal.classList.contains("show")
       ) {

           return;
       }


       /*
        * If popup is already visible,
        * don't request another popup.
        */

       if (
           elements.popupOverlay &&
           elements.popupOverlay.classList.contains("show")
       ) {

           return;
       }


       reminderCheckRunning = true;


       /*
        * CHECK BACKEND
        */

       fetch(
           reminderContextPath +
           "/check-reminder-popup",
           {
               method: "GET",

               credentials: "same-origin",

               cache: "no-store"
           }
       )
       .then(function(response) {

           /*
            * Check HTTP status
            */

           if (!response.ok) {

               throw new Error(
                   "HTTP " +
                   response.status
               );
           }


           /*
            * Convert response to JSON
            */

           return response.json();
       })
       .then(function(data) {

           console.log(
               "Reminder check response:",
               data
           );


           /* =================================================
              ARRAY RESPONSE
              ================================================= */

           if (
               data &&
               data.success &&
               Array.isArray(data.reminders)
           ) {

               if (
                   data.reminders.length > 0
               ) {

                   reminderQueue =
                       data.reminders.slice();

                   showNextReminder();

               } else {

                   reminderQueue = [];
               }


               return;
           }


           /* =================================================
              SINGLE REMINDER RESPONSE
              ================================================= */

           if (
               data &&
               data.success &&
               data.reminder
           ) {

               reminderQueue = [
                   data.reminder
               ];

               showNextReminder();

               return;
           }


           /*
            * No reminders
            */

           reminderQueue = [];

       })
       .catch(function(error) {

           console.error(
               "Reminder check error:",
               error
           );

       })
       .finally(function() {

           /*
            * Allow the next check
            */

           reminderCheckRunning = false;

       });
   }


/* =========================================================
   SHOW NEXT REMINDER
   ========================================================= */

function showNextReminder() {

    /*
     * Nothing left.
     */

    if (
        !reminderQueue ||
        reminderQueue.length === 0
    ) {

        currentReminder =
            null;

        return;
    }


    /*
     * Don't show while Edit modal
     * is open.
     */

    const elements =
        getReminderElements();


    if (
        elements.editModal &&
        elements.editModal.classList.contains(
            "show"
        )
    ) {

        return;
    }


    /*
     * Take first reminder.
     */

    const nextReminder =
        reminderQueue.shift();


    currentReminder =
        nextReminder;


    showReminderPopup(
        nextReminder
    );
}


/* =========================================================
   SHOW REMINDER POPUP
   ========================================================= */

function showReminderPopup(
    reminder
) {

    if (!reminder) {

        showNextReminder();

        return;
    }


    const elements =
        getReminderElements();


    if (
        !elements.popupOverlay
    ) {

        console.error(
            "Reminder popup overlay not found."
        );

        return;
    }


    /*
     * Move popup to body.
     */

    if (
        elements.popupOverlay.parentElement !==
            document.body
    ) {

        document.body.appendChild(
            elements.popupOverlay
        );
    }


    /* -----------------------------------------
       REMINDER DATA
       ----------------------------------------- */

    const name =
        reminder.reminderName ||
        reminder.name ||
        "Reminder";


    const type =
        reminder.reminderType ||
        reminder.type ||
        "REMINDER";


    const message =
        reminder.message ||
        "You have a reminder.";


    const time =
        reminder.reminderTime ||
        reminder.time ||
        "--";


    /* -----------------------------------------
       SET POPUP CONTENT
       ----------------------------------------- */

    if (
        elements.popupType
    ) {

        elements.popupType.textContent =
            type;
    }


    if (
        elements.popupTitle
    ) {

        elements.popupTitle.textContent =
            name;
    }


    if (
        elements.popupMessage
    ) {

        elements.popupMessage.textContent =
            message;
    }


    if (
        elements.popupTime
    ) {

        elements.popupTime.textContent =
            formatReminderTime(
                time
            );
    }


    /* -----------------------------------------
       ENABLE BUTTONS
       ----------------------------------------- */

    if (
        elements.viewButton
    ) {

        elements.viewButton.disabled =
            false;
    }


    if (
        elements.dismissButton
    ) {

        elements.dismissButton.disabled =
            false;
    }


    /* -----------------------------------------
       SHOW POPUP
       ----------------------------------------- */

    elements.popupOverlay.style.display =
        "flex";


    elements.popupOverlay.style.position =
        "fixed";


    elements.popupOverlay.style.top =
        "0";


    elements.popupOverlay.style.left =
        "0";


    elements.popupOverlay.style.width =
        "100vw";


    elements.popupOverlay.style.height =
        "100vh";


    elements.popupOverlay.style.zIndex =
        "2147483647";


    elements.popupOverlay.classList.add(
        "show"
    );


    document.body.style.overflow =
        "hidden";


    console.log(
        "Showing reminder:",
        reminder
    );
}


/* =========================================================
   FORMAT TIME
   ========================================================= */

function formatReminderTime(
    time
) {

    if (!time) {

        return "--";
    }


    const value =
        String(time);


    /*
     * If backend gives:
     *
     * 18:00:00
     */

    const parts =
        value.split(":");


    if (
        parts.length < 2
    ) {

        return value;
    }


    let hours =
        parseInt(
            parts[0],
            10
        );


    const minutes =
        parts[1];


    if (
        isNaN(hours)
    ) {

        return value;
    }


    const suffix =
        hours >= 12
            ? "PM"
            : "AM";


    hours =
        hours % 12;


    if (
        hours === 0
    ) {

        hours = 12;
    }


    return (
        String(hours).padStart(2, "0") +
        ":" +
        minutes +
        " " +
        suffix
    );
}


/* =========================================================
   DISMISS CURRENT REMINDER
   ========================================================= */

   /* =========================================================
      DISMISS CURRENT REMINDER
      ========================================================= */

   function dismissCurrentReminder() {

       if (!currentReminder) {
           return;
       }

       var elements = getReminderElements();

       if (elements.dismissButton) {
           elements.dismissButton.disabled = true;
       }

       var occurrenceId =
           currentReminder.occurrenceId;

       if (!occurrenceId) {

           console.error(
               "Occurrence ID missing:",
               currentReminder
           );

           hideReminderPopup();

           showNextReminder();

           return;
       }

       fetch(
           reminderContextPath +
           "/dismiss-reminder",
           {
               method: "POST",

               headers: {
                   "Content-Type":
                       "application/x-www-form-urlencoded"
               },

               credentials: "same-origin",

               body:
                   "occurrenceId=" +
                   encodeURIComponent(
                       occurrenceId
                   )
           }
       )
       .then(function(response) {

           if (!response.ok) {

               throw new Error(
                   "HTTP " +
                   response.status
               );
           }

           return response.json();
       })
       .then(function(data) {

           console.log(
               "Dismiss response:",
               data
           );

           if (
               data &&
               data.success
           ) {

               /*
                * Close popup
                */
               hideReminderPopup();

               /*
                * Show next reminder
                */
               setTimeout(
                   function() {

                       showNextReminder();

                   },
                   250
               );

           } else {

               alert(
                   data &&
                   data.message
                       ? data.message
                       : "Unable to dismiss reminder."
               );

               if (elements.dismissButton) {

                   elements.dismissButton.disabled =
                       false;
               }
           }

       })
       .catch(function(error) {

           console.error(
               "Dismiss reminder error:",
               error
           );

           alert(
               "Server error while dismissing reminder."
           );

           if (elements.dismissButton) {

               elements.dismissButton.disabled =
                   false;
           }
       });
   }


/* =========================================================
   HIDE REMINDER POPUP
   ========================================================= */

function hideReminderPopup() {

    const elements =
        getReminderElements();


    if (
        elements.popupOverlay
    ) {

        elements.popupOverlay.classList.remove(
            "show"
        );


        elements.popupOverlay.style.display =
            "none";
    }


    document.body.style.overflow =
        "";


    currentReminder =
        null;
}


/* =========================================================
   VIEW REMINDER DETAILS
   ========================================================= */

function viewCurrentReminder() {

    if (
        !currentReminder
    ) {

        return;
    }


    const reminder =
        currentReminder;


    console.log(
        "Viewing reminder:",
        reminder
    );


    /*
     * Hide popup first.
     */

    hideReminderPopup();


    /*
     * For now, open Reminder Center.
     *
     * Later we can make this navigate
     * to the exact event/payment page
     * based on reminder type.
     */

    window.location.href =
        reminderContextPath +
        "/reminders";
}


/* =========================================================
   POPUP BUTTON EVENTS
   ========================================================= */

document.addEventListener(
    "click",
    function (event) {

        const elements =
            getReminderElements();


        /*
         * Dismiss
         */

        if (
            event.target.closest(
                "#reminderDismissBtn"
            )
        ) {

            dismissCurrentReminder();

            return;
        }


        /*
         * View details
         */

        if (
            event.target.closest(
                "#reminderViewDetailsBtn"
            )
        ) {

            viewCurrentReminder();

            return;
        }


        /*
         * Close Edit modal by clicking
         * outside the modal content.
         */

        if (
            event.target.id ===
            "editReminderModal"
        ) {

            window.closeReminderModal();
        }
    }
);


/* =========================================================
   ESC KEY
   ========================================================= */

document.addEventListener(
    "keydown",
    function (event) {

        if (
            event.key === "Escape"
        ) {

            const elements =
                getReminderElements();


            /*
             * Close Edit modal first.
             */

            if (
                elements.editModal &&
                elements.editModal.classList.contains(
                    "show"
                )
            ) {

                window.closeReminderModal();

                return;
            }


            /*
             * Close reminder popup.
             *
             * Note:
             * Dismiss should normally be used
             * to mark it dismissed in database.
             */

            if (
                elements.popupOverlay &&
                elements.popupOverlay.classList.contains(
                    "show"
                )
            ) {

                hideReminderPopup();
            }
        }
    }
);


/* =========================================================
   EXPORT FUNCTIONS
   ========================================================= */

window.checkReminders =
    checkReminders;

window.showNextReminder =
    showNextReminder;

window.dismissCurrentReminder =
    dismissCurrentReminder;

window.hideReminderPopup =
    hideReminderPopup;

window.viewCurrentReminder =
    viewCurrentReminder;


/* =========================================================
   FINAL INITIALIZATION
   ========================================================= */

setTimeout(
    function () {

        moveReminderElementsToBody();

    },
    100
);