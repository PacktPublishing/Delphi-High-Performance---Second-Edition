unit Spring.Collections.Adapters;

interface

uses
  Generics.Collections,
  Spring.Collections,
  Spring.Collections.Base;

type
  TEnumerableHelper = class helper for TEnumerable
  private type
    TEnumerableAdapter<T> = class(TEnumerableBase<T>, IEnumerable<T>)
    private type
      TGenericEnumerable = Generics.Collections.TEnumerable<T>;
    private
      fSource: TGenericEnumerable;
    public
      constructor Create(const source: TGenericEnumerable);
      function GetEnumerator: IEnumerator<T>;
    end;

    TEnumeratorAdapter<T> = class(TInterfacedObject, IEnumerator<T>)
    private type
      TGenericEnumerator = Generics.Collections.TEnumerator<T>;
    private
      fSource: TGenericEnumerator;
    protected
      function GetCurrent: T;
    public
      constructor Create(const source: TGenericEnumerator);
      destructor Destroy; override;
      function MoveNext: Boolean;
      property Current: T read GetCurrent;
    end;
  public
    class function From<T>(const source: TEnumerable<T>): IEnumerable<T>; overload; static;
  end;

implementation


{$REGION 'TEnumerableHelper'}

class function TEnumerableHelper.From<T>(
  const source: TEnumerable<T>): IEnumerable<T>;
begin
  Result := TEnumerableAdapter<T>.Create(source);
end;

{$ENDREGION}


{$REGION 'TEnumerableHelper.TEnumerableAdapter<T>'}

constructor TEnumerableHelper.TEnumerableAdapter<T>.Create(
  const source: TGenericEnumerable);
begin
  inherited Create;
  fSource := source;
end;

function TEnumerableHelper.TEnumerableAdapter<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TEnumeratorAdapter<T>.Create(fSource.GetEnumerator());
end;

{$ENDREGION}


{$REGION 'TEnumerableHelper.TEnumeratorAdapter<T>'}

constructor TEnumerableHelper.TEnumeratorAdapter<T>.Create(
  const source: TGenericEnumerator);
begin
  inherited Create;
  fSource := source;
end;

destructor TEnumerableHelper.TEnumeratorAdapter<T>.Destroy;
begin
  fSource.Free;
  inherited Destroy;
end;

function TEnumerableHelper.TEnumeratorAdapter<T>.GetCurrent: T;
begin
  Result := fSource.Current;
end;

function TEnumerableHelper.TEnumeratorAdapter<T>.MoveNext: Boolean;
begin
  Result := fSource.MoveNext;
end;

{$ENDREGION}


end.