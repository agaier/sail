try: paraview.simple
except: from paraview.simple import *
paraview.simple._DisableFirstRenderCameraReset()

#case1_OpenFOAM = OpenFOAMReader(FileName='./case1.foam')
#case1_OpenFOAM = OpenFOAMReader( FileName='/home/adam/Code/ffdSail/domains/velo/openFoam/case1/case1.foam' )
case1_OpenFOAM = GetActiveSource()
case1_OpenFOAM.VolumeFields = ['p', 'U']
case1_OpenFOAM.MeshParts = ['internalMesh', 'parsecWingGroup - group']

RenderView1 = GetRenderView()
RenderView1.CenterOfRotation = [5.0, 0.0, 9.949999999254942]

DataRepresentation1 = Show()
DataRepresentation1.EdgeColor = [0.0, 0.0, 0.5000076295109483]
DataRepresentation1.SelectionPointFieldDataArrayName = 'p'
DataRepresentation1.SelectionCellFieldDataArrayName = 'p'
DataRepresentation1.Representation = 'Outline'
DataRepresentation1.ScaleFactor = 2.0100000001490117

RenderView1.CameraViewUp = [0.21490793990352405, 0.18171955624199604, 0.9595793767300522]
RenderView1.CameraPosition = [-1.1286768239721, -0.942014999639298, 0.857584511221304]
RenderView1.CameraClippingRange = [0.033173287072907655, 33.173287072907655]
RenderView1.CameraFocalPoint = [56.4414000477271, 28.0594363879556, -17.5279684976728]
RenderView1.CameraParallelScale = 17.3494236219817
RenderView1.CenterOfRotation = [0.10446995698906, -0.0167364384331545, 0.292973668537272]

AnimationScene1 = GetAnimationScene()
AnimationScene1.AnimationTime = 100.0

DataRepresentation1.Representation = 'Surface With Edges'
DataRepresentation1.ColorArrayName = ('CELL_DATA', 'p')
DataRepresentation1.ColorAttributeType = 'CELL_DATA'

a1_p_PVLookupTable = GetLookupTableForArray( "p", 1, RGBPoints=[-120.90714263916016, 0.23, 0.299, 0.754, 50.4218635559082, 0.865, 0.865, 0.865, 221.75086975097656, 0.706, 0.016, 0.15], VectorMode='Magnitude', NanColor=[0.25, 0.0, 0.0], ColorSpace='Diverging', ScalarRangeInitialized=1.0 )

a1_p_PiecewiseFunction = CreatePiecewiseFunction( Points=[-120.90714263916016, 0.0, 0.5, 0.0, 221.75086975097656, 1.0, 0.5, 0.0] )

StreamTracer1 = StreamTracer( SeedType="Point Source" )

DataRepresentation1.LookupTable = a1_p_PVLookupTable

a1_p_PVLookupTable.ScalarOpacityFunction = a1_p_PiecewiseFunction

StreamTracer1.SeedType.Center = [5.0, 0.0, 9.949999999254942]
StreamTracer1.SeedType.Radius = 2.0100000001490117
StreamTracer1.Vectors = ['POINTS', 'U']
StreamTracer1.SeedType = "Point Source"
StreamTracer1.MaximumStreamlineLength = 20.100000001490116

# toggle the 3D widget visibility.
active_objects.source.SMProxy.InvokeEvent('UserEvent', 'ShowWidget')
StreamTracer1.SeedType.Radius = 0.2
StreamTracer1.SeedType.NumberOfPoints = 150
StreamTracer1.SeedType.Center = [0.0, 0.0, 0.25]

DataRepresentation2 = Show()
DataRepresentation2.EdgeColor = [0.0, 0.0, 0.5000076295109483]
DataRepresentation2.ColorAttributeType = 'POINT_DATA'
DataRepresentation2.SelectionPointFieldDataArrayName = 'AngularVelocity'
DataRepresentation2.SelectionCellFieldDataArrayName = 'ReasonForTermination'
DataRepresentation2.ColorArrayName = ('POINT_DATA', '')
DataRepresentation2.ScaleFactor = 1.9856109142303469

DataRepresentation1.Visibility = 0

RenderView1.CameraClippingRange = [0.025606294244704078, 25.606294244704078]

DataRepresentation1.Visibility = 1

RenderView1.CameraClippingRange = [0.033173287072907655, 33.173287072907655]

WriteImage('velo.jpg')


Render()