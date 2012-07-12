
Local app:TApplication = New TApplication
app.Create()

While app.running
	app.Poll()
Wend

End