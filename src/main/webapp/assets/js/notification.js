// ======================================
// Notification System
// ======================================
let dismissedReminderIds =
    JSON.parse(localStorage.getItem("dismissedReminderIds") || "[]");
document.addEventListener("DOMContentLoaded", function () {

    loadNotificationCount();

    loadNotifications();

    document.getElementById("closeNotification")
        .addEventListener("click", closeNotifications);

    document.getElementById("notificationOverlay")
        .addEventListener("click", function(e){

            if(e.target.id==="notificationOverlay"){

                closeNotifications();

            }

        });

    document.addEventListener("keydown",function(e){

        if(e.key==="Escape"){

            closeNotifications();

        }

    });

    document.getElementById("markAllRead")
        .addEventListener("click",markAllNotificationsRead);

    document.getElementById("deleteAllBtn")
        .addEventListener("click",deleteAllNotifications);

    setInterval(function(){

        loadNotificationCount();

        loadNotifications();

    },30000);

});

function openNotifications(){

    loadNotifications();

    loadNotificationCount();

    document.getElementById("notificationOverlay")
            .classList.add("show");

}

function closeNotifications(){

    document.getElementById("notificationOverlay")
            .classList.remove("show");

}



// ======================================
// Load Notification Count
// ======================================

function loadNotificationCount(){

    fetch(contextPath + "/notifications?action=count")
    .then(response => response.json())

    .then(data =>{

        document.getElementById("notificationCount").innerHTML =
            data.count;

    })

    .catch(error=>console.error(error));

}

// ======================================
// Format Time
// ======================================

function formatTime(dateString){

    const date = new Date(dateString);

    const now = new Date();

    const seconds =
        Math.floor((now-date)/1000);

    if(seconds<60){

        return "Just now";

    }

    if(seconds<3600){

        return Math.floor(seconds/60)+" minutes ago";

    }

    if(seconds<86400){

        return Math.floor(seconds/3600)+" hours ago";

    }

    if(seconds<172800){

        return "Yesterday";

    }

    return date.toLocaleDateString("en-IN",{

        day:"numeric",

        month:"short",

        year:"numeric"

    });

}

// ======================================
// Mark All Notifications Read
// ======================================

function markAllNotificationsRead(){

    fetch("mark-all-notifications-read")

    .then(response=>response.json())

    .then(data=>{

        if(data.success){

            loadNotifications();

            loadNotificationCount();

        }

    });

}

// ======================================
// Delete All Notifications
// ======================================

function deleteAllNotifications(){

    if(!confirm("Delete all notifications?")){

        return;

    }

    fetch("delete-all-notifications")

    .then(response=>response.json())

    .then(data=>{

        if(data.success){

            loadNotifications();

            loadNotificationCount();

        }

    });

}

function formatReminderMessage(message){

    let html = "";

    const lines = message.split("\n");

    let openCard = false;

    lines.forEach(function(line){

        line = line.trim();

        if(line==="") return;

        if(line.startsWith("👤")){

            if(openCard){

                html += "</div>";

            }

            html += "<div class='reminder-card-item payment-reminder'>";

            html += "<div class='pending-name'>"+line+"</div>";

            openCard = true;

        }

        else if(line.startsWith("📅")){

            html += "<div class='pending-event'>"+line+"</div>";

        }

        else if(line.startsWith("💵")){

            html += "<div class='pending-amount'>"+line+"</div>";

        }

        else if(line.includes("━━━━━━━━")){

            if(openCard){

                html += "</div>";

                openCard = false;

            }

            html += "<hr>";

        }

        else{

            html += "<div>"+line+"</div>";

        }

    });

    if(openCard){

        html += "</div>";

    }

    return html;

}

// ======================================
// Load Notifications
// ======================================

function loadNotifications(){

    fetch(contextPath + "/notifications?action=list")

    .then(response=>response.json())

    .then(data=>{

        const container =
            document.getElementById("notificationContainer");

        container.innerHTML="";

        document.getElementById("totalNotifications").innerText =
            data.length;

        if(data.length===0){

            container.innerHTML=`

                <div class="notification-empty">

                    <i class="fa-solid fa-bell-slash"></i>

                    <h3>No Notifications</h3>

                    <p>You're all caught up.</p>

                </div>

            `;

            return;

        }
		        data.forEach(function(notification){

            let icon="fa-bell";
            let color="primary";
			let formattedMessage = notification.message;

			if(notification.action === "REMINDER"){

			    formattedMessage =
			        formatReminderMessage(notification.message);

			}
            // ===========================
            // Reminder Notifications
            // ===========================

            if(notification.action==="REMINDER"){

                if(notification.title.includes("Today")){

                    icon="fa-sun";
                    color="success";

                }

                else if(notification.title.includes("Tomorrow")){

                    icon="fa-moon";
                    color="primary";

                }

                else if(notification.title.includes("Pending")){

                    icon="fa-money-bill-wave";
                    color="warning";

                }

            }

            // ===========================
            // Customer
            // ===========================

            else if(notification.module==="CUSTOMER"){

                icon="fa-user";
                color="success";

            }

            // ===========================
            // Event
            // ===========================

            else if(notification.module==="EVENT"){

                if(notification.action==="ADD"){

                    icon="fa-calendar-plus";

                }

                else if(notification.action==="UPDATE"){

                    icon="fa-pen";

                }

                else if(notification.action==="PAYMENT_RECEIVED"){

                    icon="fa-wallet";

                }

                else{

                    icon="fa-calendar";

                }

                color="primary";

            }

            // ===========================
            // Bulk Event
            // ===========================

            else if(notification.module==="BULK_EVENT"){

                icon="fa-users";
                color="warning";

            }

            container.innerHTML+=`

                <div class="notification-card ${color}
                ${notification.isRead ? "" : "unread"}">

                    <div class="notification-left">

                        <div class="notification-icon">

                            <i class="fa-solid ${icon}"></i>

                        </div>

                        <div class="notification-details">

                            <div class="notification-title">

                                ${notification.title}

                            </div>

							<div class="notification-message">

							    ${formattedMessage}

							</div>

                            <div class="notification-date">

                                ${notification.createdAt}

                            </div>

                        </div>

                    </div>

                    <div class="notification-meta">

                        <div class="notification-time">

                            <i class="fa-regular fa-clock"></i>

                            ${formatTime(notification.createdAt)}

                        </div>

                        <span class="notification-module ${color}">

                            ● ${notification.module}

                        </span>

                        <button
                            class="delete-btn"

                            onclick="deleteNotification(${notification.notificationId})">

                            <i class="fa-solid fa-trash"></i>

                        </button>

                    </div>

                </div>

            `;

        });

    })

    .catch(error=>console.error(error));

}
// ======================================
// Delete Single Notification
// ======================================

function deleteNotification(notificationId){

    if(!confirm("Delete this notification?")){

        return;

    }

    fetch("delete-notification?id="+notificationId)

    .then(response=>response.json())

    .then(data=>{

        if(data.success){

            loadNotifications();

            loadNotificationCount();

        }

    })

    .catch(error=>console.error(error));

}


// ======================================
// Global Toast
// ======================================

document.addEventListener("DOMContentLoaded",function(){

    const toast =
        document.getElementById("globalToast");

    if(!toast){

        return;

    }

    const title =
        document.getElementById("toastTitle");

    if(!title || title.innerText.trim()===""){

        toast.style.display="none";

        return;

    }

    const icon =
        document.getElementById("toastIcon");

    if(toast.classList.contains("success")){

        icon.className=
            "fa-solid fa-circle-check";

    }

    else if(toast.classList.contains("error")){

        icon.className=
            "fa-solid fa-circle-xmark";

    }

    else if(toast.classList.contains("warning")){

        icon.className=
            "fa-solid fa-triangle-exclamation";

    }

    else{

        icon.className=
            "fa-solid fa-circle-info";

    }

    setTimeout(function(){

        toast.classList.add("show");

    },150);

    setTimeout(function(){

        toast.classList.remove("show");

    },3000);

    document.getElementById("toastClose")
            .addEventListener("click",function(){

        toast.classList.remove("show");

    });

});