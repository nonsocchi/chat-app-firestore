const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.myFunction = functions.firestore
    .document("chat/{message}")
    .onCreate((snap, context) => {
      // Get an object representing the document
      // e.g. {'name': 'Marie', 'age': 66}

      return admin.messaging().sendToTopic("chat", {
        notification: {
          title: snap.data().username,
          body: snap.data().text,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      });

      // access a particular field as you would any JS property
      //   const name = newValue.name;

    // perform desired operations ...
    });
