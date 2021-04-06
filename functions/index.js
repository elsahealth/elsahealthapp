// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');
// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

const stripe = require('stripe')(functions.config().stripe.secret, {
    apiVersion: '2020-03-02',
});

/**
 * Create a Stripe object upon new user creation
 */
 exports.createStripeCustomer = functions.auth.user().onCreate(async (user) => {
    const customer = await stripe.customers.create({
      email: user.email,
      metadata: { firebaseUID: user.uid },
    });
  
    await admin.firestore().collection('stripe_customers').doc(user.uid).set({
      customer_id: customer.id,
    });
    return;
  });