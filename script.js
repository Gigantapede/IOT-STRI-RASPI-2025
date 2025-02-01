var calendar = {
    events: {
        course: {
            events: [],
            className: ['event', 'course'],
            allDayDefault: false
        },
        leave: {
            events: [],
            className: ['event', 'leave'],
            allDayDefault: true
        },
        holiday: {
            events: [],
            className: ['event', 'holiday'],
            allDayDefault: true
        },
        attendance: {
            absent: {
                events: [],
                className: ['event', 'attendance', 'absent'],
                allDayDefault: true
            },
            late: {
                events: [],
                className: ['event', 'attendance', 'late'],
                allDayDefault: true
            },
            ontime: {
                events: [],
                className: ['event', 'attendance', 'ontime'],
                allDayDefault: true
            },
            undertime: {
                events: [],
                className: ['event', 'attendance', 'undertime'],
                allDayDefault: true
            }
        },
        birthday: {
            events: [],
            className: ['event', 'birthday'],
            allDayDefault: true
        }
    },
    currentCourses: [],
    fetching: false,
    lastUpdate: null,
    autoUpdateInterval: null,

    // Initialize calendar
    init: function () {
        this.initCalendar();
        this.startAutoUpdate();
    },

    initCalendar: function () {
        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            },
            defaultView: 'month',
            timeFormat: 'HH:mm', // Use 24-hour format
            events: (start, end, timezone, callback) => {
                this.fetchCourseEvents(start, end, callback);
            },
            eventRender: (event, element) => {
                element.find('.fc-title').html(event.title);
                if (event.entries?.some(entry => entry.status === 'Absent')) {
                    element.addClass('has-absent');
                }

                // Add data attribute for updates
                element.attr('data-course-id', event.idCours);

                // Add visual update indicator
                if (event.last_updated > this.lastUpdate) {
                    element.addClass('new-update');
                    setTimeout(() => element.removeClass('new-update'), 2000);
                }
            },
            eventClick: (calEvent, jsEvent) => {
                this.handleEventClick(calEvent, jsEvent);
            },
            dayClick: (date, jsEvent) => {
                const events = $('#calendar').fullCalendar('clientEvents',
                    e => e.start.isSame(date, 'day')
                );
                if (events.length) {
                    this.listEvents('mixed', events.flatMap(e => e.entries), date.format());
                    this.showCard(jsEvent);
                }
            }
        });
    },

    // Auto-update functionality
    startAutoUpdate: function () {
        this.autoUpdateInterval = setInterval(() => this.checkForUpdates(), 30000);
    },

    // Modified checkForUpdates
    checkForUpdates: function () {
        if (this.fetching) return;

        fetch('/api/courses/check-updates', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ lastUpdate: this.lastUpdate })
        })
            .then(res => res.json())
            .then(data => {
                console.log('Update check:', data);
                if (data.updated) {
                    console.log('Refreshing calendar...');
                    this.lastUpdate = data.newTimestamp;
                    this.refreshCalendarData();
                }
            })
            .catch(console.error);
    },

    refreshCalendarData: function () {
        const $calendar = $('#calendar');

        // Force clear existing events
        $calendar.fullCalendar('removeEvents');

        // Get current view dates
        const view = $calendar.fullCalendar('getView');

        // Refetch fresh data
        this.fetchCourseEvents(view.start, view.end, (events) => {
            $calendar.fullCalendar('addEventSource', events);
            $calendar.fullCalendar('rerenderEvents');
            this.refreshOpenDetails();
        });
    },

    refreshOpenDetails: function () {
        const activeEntry = $('.entry.active');
        if (activeEntry.length) {
            const type = activeEntry.data('type');
            const date = activeEntry.data('date');
            const id = activeEntry.data('id');
            this.showDetail(type, date, id);
        }
    },

    // Data fetching
    fetchCourseEvents: function (start, end, callback) {
        if (this.fetching) return;
        this.fetching = true;

        fetch('/api/courses', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                start: start.format('YYYY-MM-DD HH:mm:ss'),
                end: end.format('YYYY-MM-DD HH:mm:ss'),
                filters: { course: $('#filter-course').prop('checked') }
            })
        })
            .then(res => res.json())
            .then(data => {
                console.log('Fetched courses:', data.courses.length, 'items');
                console.log('New timestamp:', data.timestamp);
                this.lastUpdate = data.timestamp;
                this.currentCourses = data.courses.map(course => ({
                    title: `${course.Libelle} (${course.nomSalle})`,
                    start: moment(course.DateInit).format('YYYY-MM-DD HH:mm:ss'),
                    end: moment(course.DateFin).format('YYYY-MM-DD HH:mm:ss'),
                    className: ['event', 'course'],
                    eventType: 'course',
                    entries: course.attendees.map(attendee => ({
                        id: attendee.idBadge,
                        name: `${attendee.prenom} ${attendee.nom}`,
                        status: attendee.Present ? 'Present' : 'Absent',
                        lastDetection: attendee.derniereDetectionPresence,
                        nomSalle: course.nomSalle
                    }))
                }));
                callback(this.currentCourses);
                this.fetching = false;
            })
            .catch(err => {
                console.error('Fetch error:', err);
                callback([]);
                this.fetching = false;
            });
    },

    // Event handling
    handleEventClick: function (calEvent, jsEvent) {
        if (calEvent.eventType === 'course') {
            this.listCourseAttendees(calEvent);
            this.showCard(jsEvent);
        } else {
            if (calEvent.entries.length > 1) {
                this.listEvents(calEvent.eventType, calEvent.entries, calEvent.start.format());
                this.showCard(jsEvent);
            } else {
                this.showDetail(calEvent.eventType, calEvent.start.format(), calEvent.entries[0].id);
                $('.card').addClass('flipped');
            }
        }
    },

    listCourseAttendees: function (courseEvent) {
        $('.front-panel .event-title').html(`<span class="course">COURSE</span>`);
        $('.front-panel .event-date').html(moment(courseEvent.start).format("dddd, MMMM Do YYYY"));
        this.listEvents('course', courseEvent.entries, courseEvent.start.format());
    },

    showCard: function (jsEvent) {
        const target = $(jsEvent.currentTarget);
        const parent = target.parent();
        $('.card-wrapper').css({
            top: parent.offset().top + 2,
            left: target.offset().left + parent.width() + 4,
            display: 'block'
        }).show();
        $('.card').css({ opacity: 1, transform: 'scale(1)' });
    },

    listEvents: function (type, entries, date) {
        if (this.fetching) return;
        this.fetching = true;

        $('.front-panel .entries').html('').parent().find('.event-loader').show();

        setTimeout(() => {
            entries.forEach(entry => {
                const statusClass = entry.status.toLowerCase();
                const entryEl = $(`
                    <div class="entry" data-type="${type}" data-id="${entry.id}" data-date="${date}">
                        <div class="entry-details">
                            <p class="entry-name">${entry.name}</p>
                            <p class="entry-status ${statusClass}">
                                ${entry.status} 
                                <span class="detection-time">
                                    ${moment(entry.lastDetection).format('HH:mm')}
                                </span>
                            </p>
                        </div>
                    </div>
                `);
                $('.front-panel .entries').append(entryEl);
            });

            $('.front-panel .event-loader').hide();
            this.fetching = false;
        }, 300);
    },

    showDetail: function (type, date, id) {
        $('.back-panel .event-detail').hide().html('');
        $('.back-panel .event-loader').show();

        const event = this.currentCourses.find(e =>
            moment(e.start).format() === moment(date).format() &&
            e.entries.some(entry => entry.id === id)
        );

        if (event) {
            const entry = event.entries.find(e => e.id === id);
            const detailHtml = `
                <p class="emp-name">${entry.name}</p>
                <p class="event-date">${moment(date).format("dddd, MMMM Do YYYY")}</p>
                <div class="presence-details">
                    <p>Status: <span class="${entry.status.toLowerCase()}">${entry.status}</span></p>
                    <p>Last Detection: ${moment(entry.lastDetection).format('YYYY-MM-DD HH:mm:ss')}</p>
                    ${event.nomSalle ? `<p>Room: ${event.nomSalle}</p>` : ''}
                </div>`;

            $('.back-panel .event-detail').html(detailHtml);
        }

        setTimeout(() => {
            $('.back-panel .event-loader').hide();
            $('.back-panel .event-detail').show();
        }, 300);
    },

    closeCard: function () {
        $('.card').css({ opacity: 0, transform: 'scale(0.8)' });
        setTimeout(() => {
            $('.card-wrapper').hide();
            $('.back-panel .event-detail').empty().hide();
        }, 300);
    }
};

// Initialize on page load
$(document).ready(() => {
    calendar.init();

    // Event listeners
    $('.filter input').on('change', () => {
        $('#calendar').fullCalendar('refetchEvents');
        calendar.closeCard();
    });

    $(document).on('click', '.entry', function () {
        const type = $(this).data('type');
        const date = $(this).data('date');
        const id = $(this).data('id');
        calendar.showDetail(type, date, id);
        $('.card').addClass('flipped');
        $(this).addClass('active').siblings().removeClass('active');
    });

    $(document).on('click', e => {
        if (!$(e.target).closest('.card, .fc-event').length) {
            calendar.closeCard();
        }
    });

    $('#sidebar-toggle').click(() => {
        $(this).toggleClass('active');
        $('.sidebar').toggleClass('collapsed');
    });
});

// Dynamic styles
$('<style>').prop('type', 'text/css').html(`
    .fc-event.course { background: #4CAF50; border-color: #45a049; }
    .fc-event.has-absent { background: #ff9800; }
    .entry-status.present { color: #4CAF50; }
    .entry-status.absent { color: #f44336; }
    .detection-time { float: right; font-size: 0.9em; opacity: 0.8; }
    .card { transition: all 0.3s; transform-style: preserve-3d; }
    .front-panel, .back-panel { backface-visibility: hidden; position: absolute; width: 100%; height: 100%; }
    .back-panel { transform: rotateY(180deg); }
    .card.flipped { transform: rotateY(180deg); }
    .card-wrapper { display: none; position: absolute; z-index: 1000; }
`).appendTo('head');