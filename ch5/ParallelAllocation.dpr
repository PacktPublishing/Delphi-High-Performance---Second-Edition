program ParallelAllocation;

uses
//  FastMM4 in 'FastMM\FastMM4.pas',
//  cmem in 'tbbmalloc\cmem_xe\cmem.pas',
//  FastMM5 in 'FastMM5\FastMM5.pas',
  Vcl.Forms,
  ParallelAllocationMain in 'ParallelAllocationMain.pas' {frmParallelAllocation};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmParallelAllocation, frmParallelAllocation);
  Application.Run;
end.
