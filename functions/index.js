const functions = require("firebase-functions");

exports.myFunction = functions.database
  .ref("messeges/{push_id}")
  .onCreate((snapshot, context) => {
    console.log(snapshot.data());
    return;
  });
