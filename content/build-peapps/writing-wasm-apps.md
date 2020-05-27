Note that you'll want to ensure no resource leakage when you load external resources, or you may totally defeat the whole point of the anonymity you're getting from the mixnet. 

Setting up request data in a Sphinx packet does protect you from all the leakage that gets sent in a browser HTTP request. This is a big advantage: as an application developer you're only sending info that you explicitly think is secure to send. Make sure you don't send anything that could publicly identify a user!

The use of Sphinx in browser tech is basically for (a) mobile apps and (b) client-side apps (e.g. Electron or similar). While it's possible to deliver web apps and build Sphinx packets using those, same-




### SURBs

Anonymous replies are possible using **S**ingle **U**se **R**eply **B**locks, or SURBs. They don't yet exist in the WebAssembly client, but should be available in the next release.

Why would you want SURBs? Keep in mind that recipients are not necessarily people: they can be privacy-respecting Service Providers, or people. SURBs allow Service Providers to respond to users without knowing who they are. 

### JSON

Sending JSON is totally possible, just stick it into the message box and send it (or send it progammatically if you're writing an application of your own).

### Key storage and webapps

keys webapps 


{{% notice warning %}}
Security note about resource leakage when building apps would be good!
{{% /notice %}}
