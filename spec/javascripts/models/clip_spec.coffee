#= require backbone/models/clip
#= require fixture/clips
#= require helpers/spec_helper

describe 'Clip',->

  clip = null

  beforeEach ->
    clip = new Clipin.Models.Clip

  it 'should set paramRoot',->
    expect(clip.paramRoot).toEqual('clip')

  describe 'when id set',->

    beforeEach ->
      clip.set('id',15)

    it 'should return the collection url and id', ->
      expect(clip.url()).toEqual('/clips/15')

    it 'should handle change event', ->
      server = sinon.fakeServer.create()
      callback = sinon.spy()
      server.respondWith("GET", "/clips/15",
              [200, {"Content-Type": "application/json"},
                    '{"audio":null,
                    "clip_count":1,
                    "created_at":"2012-09-15T13:19:32Z",
                    "description":"",
                    "id":15,
                    "image":"http://qa.atmarkit.co.jp/assets/icon-9a75e466335a6b2f437c3e53b5b547cf.png",
                    "og_type":"website",
                    "pin":false,
                    "title":"QA@IT",
                    "trash":false,
                    "updated_at":"2012-09-15T13:19:32Z",
                    "url":"http://qa.atmarkit.co.jp/",
                    "user_id":1,
                    "video":null,
                    "tags":[{"id":9,"name":"website","user_id":1}]}'
              ])
      # Bind to the change event on the model
      clip.bind('change', callback)
      clip.fetch()
      server.respond()

      expect(callback.called).toBeTruthy()
      expect(callback.getCall(0).args[0].attributes)
        .toEqual(
          id: 15
          title: "QA@IT"
          og_type: "website"
          image: "http://qa.atmarkit.co.jp/assets/icon-9a75e466335a6b2f437c3e53b5b547cf.png"
          url: "http://qa.atmarkit.co.jp/"
          description:""
          audio:null
          video:null
          created_at:"2012-09-15T13:19:32Z"
          updated_at:"2012-09-15T13:19:32Z"
          pin:false
          tags:[{"id":9,"name":"website","user_id":1}]
          clip_count:1
          user_id:1
          trash:false
        )

  it 'should set the URL to the collection URL',->
    expect(clip.url()).toEqual('/clips')

  describe 'created_at',->

    it 'should convert created_at to moment',->
      clip.set('created_at', '2012-04-08T16:45:58Z')
      expect(clip.get('created_at')).toEqual('2012-04-08T16:45:58Z') # iso8601 format is utc
      expect(clip.created_at_date().year()).toEqual(2012)
      expect(clip.created_at_date().month()).toEqual(4 - 1)
      expect(clip.created_at_date().date()).toEqual(9) # jst +9
      expect(clip.created_at_date().hours()).toEqual(1)
      expect(clip.created_at_date().minutes()).toEqual(45)

    describe 'same_created_date',->
      base = null

      beforeEach ->
        base = new Clipin.Models.Clip created_at : '2012-04-08T16:45:58Z'

      it 'should return true if same created date',->
        target = new Clipin.Models.Clip created_at :'2012-04-08T16:45:58Z'
        expect(base.same_created_date(target)).toBeTruthy()

      it 'should return false if different created date',->
        target = new Clipin.Models.Clip created_at : '2012-04-09T16:45:58Z'
        expect(base.same_created_date(target)).toBeFalsy()

  describe 'updated_at',->

    it 'should convert updated_at to moment',->
      clip.set('updated_at', '2012-04-08T16:45:58Z')
      expect(clip.get('updated_at')).toEqual('2012-04-08T16:45:58Z') # iso8601 format is utc
      expect(clip.updated_at_date().year()).toEqual(2012)
      expect(clip.updated_at_date().month()).toEqual(4 - 1)
      expect(clip.updated_at_date().date()).toEqual(9) # jst +9
      expect(clip.updated_at_date().hours()).toEqual(1)
      expect(clip.updated_at_date().minutes()).toEqual(45)

    describe 'same_updated_date',->
      base = null

      beforeEach ->
        base = new Clipin.Models.Clip updated_at : '2012-04-08T16:45:58Z'

      it 'should return true if same updated date',->
        target = new Clipin.Models.Clip updated_at :'2012-04-08T16:45:58Z'
        expect(base.same_updated_date(target)).toBeTruthy()

      it 'should return false if different updated date',->
        target = new Clipin.Models.Clip updated_at : '2012-04-09T16:45:58Z'
        expect(base.same_updated_date(target)).toBeFalsy()

describe 'ClipsCollection', ->

  beforeEach ->
    @clips = new Clipin.Collections.ClipsCollection
    @clip1 = new Clipin.Models.Clip
      id: 1
      title: 'clip1'
      created_at: '2012-09-10T21:27:00Z'
      updated_at: '2012-09-10T21:27:00Z'

    @clip2 = new Clipin.Models.Clip
      id:2
      title: 'clip2'
      created_at: '2012-09-10T21:28:00Z'
      updated_at: '2012-09-14T21:28:00Z'

    @clip3 = new Clipin.Models.Clip
      id:3
      title: 'clip3'
      created_at: '2012-09-11T21:28:00Z'
      updated_at: '2012-09-11T21:28:00Z'

  describe 'when instantiated with model literal', ->
    beforeEach ->
      @clipStub = sinon.stub(Clipin.Models, "Clip")
      @model = new Backbone.Model
        id: 5
        title: "Foo"
        updated_at : '2012-01-01T12:00:00Z'
      @clipStub.returns @model
      @clips.model = Clipin.Models.Clip
      @clips.add
        id: 5
        title: "Foo"
        updated_at : '2012-01-01T12:00:00Z'

    afterEach ->
      @clipStub.restore()

    it 'should add a model', ->
      expect(@clips.length).toEqual(1)

    it 'should find a model by id', ->
      expect(@clips.get(5).get("id")).toEqual(5)

  describe 'ordering',->
    it 'should ordered by updated_at',->
      @clips.add @clip1
      @clips.add @clip2
      @clips.add @clip3
      expect(@clip2.id).toBe(@clips.at(0).id)
      expect(@clip3.id).toBe(@clips.at(1).id)
      expect(@clip1.id).toBe(@clips.at(2).id)

  describe 'fetching models',->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    it 'should make a correct request',->
      @clips.fetch()
      expect(@server.requests.length).toEqual(1)
      expect(@server.requests[0].method).toEqual("GET")
      expect(@server.requests[0].url).toEqual("/clips")

    it 'should parse clips from the response',->
      @fixture = @fixtures.Clips.valid
      res = @validResponse(@fixture)
      @server.respondWith(
        'GET',
        '/clips',
        res)
      @clips.fetch()
      @server.respond()
      expect(@clips.length).toEqual(@fixture.length)


  it 'has default url',->
    clips = new Clipin.Collections.ClipsCollection
    expect(clips.url).toEqual('/clips')
