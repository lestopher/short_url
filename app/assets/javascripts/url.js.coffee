# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  adminPanelEl = document.getElementById('admin-panel')

  # Only do if admin-panel is on the page
  if adminPanelEl
     successCB = (response) ->
      if response.valid
        tableHeader = [
          '<thead>'
            '<tr>'
              '<th>'
                'URL'
              '</th>'
              '<th>'
                'Custom URL'
              '</th>'
              '<th>'
                'Admin Hash'
              '</th>'
              '<th>'
                'Options'
              '</th>'
            '</tr>'
          '</thead>'
        ]
        tablerowCollection = []
        tableRow = [
          '<tr>'
            '<td>'
              null # 2
            '</td>'
            '<td>'
              null # 5
            '</td>'
            '<td>'
              null # 8
            '</td>'
            '<td>'
              null # 11
            '</td>'
          '</tr>'
        ]
        editButton = [
          '<a id="table-update-url-btn" class="btn btn-mini btn-info" '
            'href="/urls/'
            null # 2
            '/edit" >'
            'Edit'
          '</a>'
        ]
        # Caching jquery object in case of future use
        $admin_panel = $('#admin-panel')

        ai = response.data
        i = 0

        while i < ai.length
          editButton[2] = ai[i].ah
          tableRow[2] = ai[i].fu
          tableRow[5] = ai[i].hu
          tableRow[8] = ai[i].ah
          tableRow[11] = editButton.join('')
          tablerowCollection.push tableRow.join('')
          ++i

        table = ['<table id="admin-table" class="table table-striped">', tableHeader.join(''), '<tbody>' , tablerowCollection.join('') , '</tbody>',  '</table>']
        $admin_panel.append(table.join(''))   # Get the admin information
      else
        $admin_panel.append('<p>Cookie was bad I guess</p>')

     admininfo = $.get '/api/admininfo.json', successCB
