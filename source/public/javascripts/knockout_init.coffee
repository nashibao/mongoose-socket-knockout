app = {}
app.models = {}
this.app = app

class ApplicationViewModel

app.vm = new ApplicationViewModel

$(document).ready =>
  ko.applyBindings app.vm
