describe 'Clip',->
  it 'should be done',->
    clip = new Clipin.Models.Clip
    expect(clip.paramRoot).toEqual('clip')

describe 'ClipsCollection', ->
  it 'has default url',->
    clips = new Clipin.Collections.ClipsCollection
    expect(clips.url).toEqual('/clips')
