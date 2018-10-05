.pragma library

function getTime() {

    var dias = {'Sun': 'Dom', 'Mon': 'Seg', 'Tue': 'Ter', 'Wed': 'Qua', 'Thu': 'Qui', 'Fri': 'Sex', 'Sat': 'Sáb'}
    var d = new Date()
    var h, m, s, date;
    var day = d.getDate()
    var mounth = d.getMonth() + 1

    h = d.getHours()
    m = d.getMinutes()

    if (day < 10) day = '0' + day
    if (mounth < 10) mounth = '0' + mounth

    date = day + '/' + mounth + '/' + d.getFullYear()

    if (h < 10) h = '0' + h
    if (m < 10) m = '0' + m

    return h + ':' + m + '|' + dias[d.toString().split(' ')[0]] + ' - ' + date;
}
