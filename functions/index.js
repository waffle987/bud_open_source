const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// When a post is created, add post to timeline of each follower (of post owner)
exports.onCreatePost = functions.firestore
    .document("/posts/{userId}/posts/{postId}")
    .onCreate(async (snapshot, context) => {
        const postCreated = snapshot.data();
        const userId = context.params.userId;
        const postId = context.params.postId;

        // 1) Get all the followers of the user who made the post
        const userFollowersRef = admin
            .firestore()
            .collection("social")
            .doc(userId)
            .collection("followers");

        const querySnapshot = await userFollowersRef.get();
        // 2) Add new post to each follower's timeline
        querySnapshot.forEach(doc => {
            const followerId = doc.id;

            admin
                .firestore()
                .collection("feed")
                .doc(followerId)
                .collection("posts")
                .doc(postId)
                .set(postCreated);
        });
    });

exports.onUpdatePost = functions.firestore
    .document("/posts/{userId}/posts/{postId}")
    .onUpdate(async (change, context) => {
        const postUpdated = change.after.data();
        const userId = context.params.userId;
        const postId = context.params.postId;

        // 1) Get all the followers of the user who made the post
        const userFollowersRef = admin
            .firestore()
            .collection("social")
            .doc(userId)
            .collection("followers");

        const querySnapshot = await userFollowersRef.get();
        // 2) Update each post in each follower's timeline
        querySnapshot.forEach(doc => {
            const followerId = doc.id;

            admin
                .firestore()
                .collection("feed")
                .doc(followerId)
                .collection("posts")
                .doc(postId)
                .get()
                .then(doc => {
                    if (doc.exists) {
                        doc.ref.update(postUpdated);
                    }
                });
        });
    });

exports.onDeletePost = functions.firestore
    .document("/posts/{userId}/posts/{postId}")
    .onDelete(async (snapshot, context) => {
        const userId = context.params.userId;
        const postId = context.params.postId;

        // 1) Get all the followers of the user who made the post
        const userFollowersRef = admin
            .firestore()
            .collection("social")
            .doc(userId)
            .collection("followers");

        const querySnapshot = await userFollowersRef.get();
        // 2) Delete each post in each follower's timeline
        querySnapshot.forEach(doc => {
            const followerId = doc.id;

            admin
                .firestore()
                .collection("feed")
                .doc(followerId)
                .collection("posts")
                .doc(postId)
                .get()
                .then(doc => {
                    if (doc.exists) {
                        doc.ref.delete();
                    }
                });
        });
    });