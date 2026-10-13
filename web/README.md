# Password reset page

`reset-password.html` is a standalone page for completing the Supabase password recovery flow. It uses the project's public anon key and sends the new password to Supabase with the one-time recovery access token from the email link. It does not use or expose a service-role key.

## Publish it

Upload `reset-password.html` to any HTTPS static web host. No build step is needed. Copy the final public URL, for example `https://your-site.example/reset-password.html`.

## Configure Supabase

In the Supabase dashboard for this project:

1. Open **Authentication → URL Configuration**.
2. Set **Site URL** to the root URL of the hosted site.
3. Add the exact `reset-password.html` URL under **Redirect URLs**.
4. Keep the **Reset Password** email template's confirmation link intact if using the default template.

## Connect the game

In `objects/obj_login/Step_0.gml`, the redirect is currently set to `https://tourmaline-melba-f456c3.netlify.app/reset-password.html`. Keep the same URL in Supabase's allowed Redirect URLs. The game appends it to `/auth/v1/recover?redirect_to=` when requesting a recovery email.

The Supabase project URL and anon key in this page match the current GameMaker project. If the Supabase project changes, update both values here and the corresponding auth scripts in the game.
