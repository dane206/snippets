(function() {
    window.dataLayer = window.dataLayer || [];

    // Generate Unique Event ID (UUID)
    function generateUUID() {
        return crypto.randomUUID ? crypto.randomUUID() : 'xxxx-xxxx-4xxx-yxxx-xxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    // Function to Store Events in `sessionStorage`
    function storeEvent(eventName, eventData) {
        try {
            var storedEvents = JSON.parse(sessionStorage.getItem("tracked_events")) || [];
            storedEvents.push({
                event: eventName,
                data: eventData,
                timestamp: new Date().toISOString()
            });
            sessionStorage.setItem("tracked_events", JSON.stringify(storedEvents));
            console.log(`✅ Stored Event in sessionStorage: ${eventName}`, eventData);
        } catch (error) {
            console.error("❌ Error storing event in sessionStorage:", error);
        }
    }

    // Ensure Script Fires Only After DOM is Ready
    document.addEventListener("DOMContentLoaded", function() {
        console.log("🔥 Tracking Script Loaded!");

        // Capture Page Data
        var pageHostname = window.location.hostname;
        var pageURL = window.location.href;
        var pageTitle = document.title;
        var referrer = document.referrer || "";

        // Detect Subdomains (edu, blog, articles, quiz, etc.)
        var subdomain = pageHostname.split(".")[0];

        // 🔥 Track `view_presale` for every page on edu.terrahealthessentials.com (or other subdomains)
        var viewPresaleEvent = {
            "event": "view_presale",
            "page_hostname": pageHostname,
            "event_url": pageURL,
            "content_id": pageTitle,
            "subdomain": subdomain,
            "lead_source": referrer,
            "currency": "USD",
            "value": 0,
            "event_id": generateUUID()
        };
        window.dataLayer.push(viewPresaleEvent);
        storeEvent("view_presale", viewPresaleEvent);
        console.log("📢 Pushed View Presale Event:", viewPresaleEvent);

        // 🔥 Track `generate_lead` before the redirect happens (ONLY IF clicking from edu.* to terrahealthessentials.com)
        document.addEventListener("click", function(event) {
            var target = event.target.closest("a");

            if (target) {
                var destinationURL = new URL(target.href);
                var destinationHostname = destinationURL.hostname;

                // Check if clicking from edu.terrahealthessentials.com to terrahealthessentials.com
                if (
                    pageHostname.includes("edu.terrahealthessentials.com") &&
                    (destinationHostname === "terrahealthessentials.com" || destinationHostname === "www.terrahealthessentials.com")
                ) {
                    var generateLeadEvent = {
                        "event": "generate_lead",
                        "destination_url": target.href,
                        "origin_url": pageURL,
                        "lead_source": referrer,
                        "subdomain": subdomain,
                        "event_id": generateUUID()
                    };

                    // Push event immediately before redirect happens
                    window.dataLayer.push(generateLeadEvent);
                    storeEvent("generate_lead", generateLeadEvent);
                    console.log("📢 Pushed Generate Lead Event:", generateLeadEvent);
                }
            }
        });

        console.log("🎯 Script Execution Completed Successfully!");
    });
})();
