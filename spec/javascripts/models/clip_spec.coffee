describe 'Clip',->

  clip = null

  beforeEach ->
    clip = new Clipin.Models.Clip


  it 'should set paramRoot',->
    expect(clip.paramRoot).toEqual('clip')

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

describe 'ClipsCollection', ->
  it 'has default url',->
    clips = new Clipin.Collections.ClipsCollection
    expect(clips.url).toEqual('/clips')
