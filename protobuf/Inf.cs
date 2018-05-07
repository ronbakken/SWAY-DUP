// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: inf.proto
#pragma warning disable 1591, 0612, 3021
#region Designer generated code

using pb = global::Google.Protobuf;
using pbc = global::Google.Protobuf.Collections;
using pbr = global::Google.Protobuf.Reflection;
using scg = global::System.Collections.Generic;
namespace InfX {

  /// <summary>Holder for reflection information generated from inf.proto</summary>
  public static partial class InfReflection {

    #region Descriptor
    /// <summary>File descriptor for inf.proto</summary>
    public static pbr::FileDescriptor Descriptor {
      get { return descriptor; }
    }
    private static pbr::FileDescriptor descriptor;

    static InfReflection() {
      byte[] descriptorData = global::System.Convert.FromBase64String(
          string.Concat(
            "CglpbmYucHJvdG8iJQoTQ29uZmlnU3ViQ2F0ZWdvcmllcxIOCgZsYWJlbHMY",
            "ASADKAkiNQoQQ29uZmlnQ2F0ZWdvcmllcxIhCgNzdWIYASADKAsyFC5Db25m",
            "aWdTdWJDYXRlZ29yaWVzIi8KBkNvbmZpZxIlCgpjYXRlZ29yaWVzGAEgASgL",
            "MhEuQ29uZmlnQ2F0ZWdvcmllcyInCgpDYXRlZ29yeUlkEgwKBG1haW4YASAB",
            "KAUSCwoDc3ViGAIgASgFIikKDUNhdGVnb3J5SWRTZXQSGAoDaWRzGAEgAygL",
            "MgsuQ2F0ZWdvcnlJZEIHqgIESW5mWGIGcHJvdG8z"));
      descriptor = pbr::FileDescriptor.FromGeneratedCode(descriptorData,
          new pbr::FileDescriptor[] { },
          new pbr::GeneratedClrTypeInfo(null, new pbr::GeneratedClrTypeInfo[] {
            new pbr::GeneratedClrTypeInfo(typeof(global::InfX.ConfigSubCategories), global::InfX.ConfigSubCategories.Parser, new[]{ "Labels" }, null, null, null),
            new pbr::GeneratedClrTypeInfo(typeof(global::InfX.ConfigCategories), global::InfX.ConfigCategories.Parser, new[]{ "Sub" }, null, null, null),
            new pbr::GeneratedClrTypeInfo(typeof(global::InfX.Config), global::InfX.Config.Parser, new[]{ "Categories" }, null, null, null),
            new pbr::GeneratedClrTypeInfo(typeof(global::InfX.CategoryId), global::InfX.CategoryId.Parser, new[]{ "Main", "Sub" }, null, null, null),
            new pbr::GeneratedClrTypeInfo(typeof(global::InfX.CategoryIdSet), global::InfX.CategoryIdSet.Parser, new[]{ "Ids" }, null, null, null)
          }));
    }
    #endregion

  }
  #region Messages
  public sealed partial class ConfigSubCategories : pb::IMessage<ConfigSubCategories> {
    private static readonly pb::MessageParser<ConfigSubCategories> _parser = new pb::MessageParser<ConfigSubCategories>(() => new ConfigSubCategories());
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pb::MessageParser<ConfigSubCategories> Parser { get { return _parser; } }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pbr::MessageDescriptor Descriptor {
      get { return global::InfX.InfReflection.Descriptor.MessageTypes[0]; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    pbr::MessageDescriptor pb::IMessage.Descriptor {
      get { return Descriptor; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public ConfigSubCategories() {
      OnConstruction();
    }

    partial void OnConstruction();

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public ConfigSubCategories(ConfigSubCategories other) : this() {
      labels_ = other.labels_.Clone();
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public ConfigSubCategories Clone() {
      return new ConfigSubCategories(this);
    }

    /// <summary>Field number for the "labels" field.</summary>
    public const int LabelsFieldNumber = 1;
    private static readonly pb::FieldCodec<string> _repeated_labels_codec
        = pb::FieldCodec.ForString(10);
    private readonly pbc::RepeatedField<string> labels_ = new pbc::RepeatedField<string>();
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public pbc::RepeatedField<string> Labels {
      get { return labels_; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override bool Equals(object other) {
      return Equals(other as ConfigSubCategories);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public bool Equals(ConfigSubCategories other) {
      if (ReferenceEquals(other, null)) {
        return false;
      }
      if (ReferenceEquals(other, this)) {
        return true;
      }
      if(!labels_.Equals(other.labels_)) return false;
      return true;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override int GetHashCode() {
      int hash = 1;
      hash ^= labels_.GetHashCode();
      return hash;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override string ToString() {
      return pb::JsonFormatter.ToDiagnosticString(this);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void WriteTo(pb::CodedOutputStream output) {
      labels_.WriteTo(output, _repeated_labels_codec);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int CalculateSize() {
      int size = 0;
      size += labels_.CalculateSize(_repeated_labels_codec);
      return size;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(ConfigSubCategories other) {
      if (other == null) {
        return;
      }
      labels_.Add(other.labels_);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(pb::CodedInputStream input) {
      uint tag;
      while ((tag = input.ReadTag()) != 0) {
        switch(tag) {
          default:
            input.SkipLastField();
            break;
          case 10: {
            labels_.AddEntriesFrom(input, _repeated_labels_codec);
            break;
          }
        }
      }
    }

  }

  public sealed partial class ConfigCategories : pb::IMessage<ConfigCategories> {
    private static readonly pb::MessageParser<ConfigCategories> _parser = new pb::MessageParser<ConfigCategories>(() => new ConfigCategories());
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pb::MessageParser<ConfigCategories> Parser { get { return _parser; } }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pbr::MessageDescriptor Descriptor {
      get { return global::InfX.InfReflection.Descriptor.MessageTypes[1]; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    pbr::MessageDescriptor pb::IMessage.Descriptor {
      get { return Descriptor; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public ConfigCategories() {
      OnConstruction();
    }

    partial void OnConstruction();

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public ConfigCategories(ConfigCategories other) : this() {
      sub_ = other.sub_.Clone();
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public ConfigCategories Clone() {
      return new ConfigCategories(this);
    }

    /// <summary>Field number for the "sub" field.</summary>
    public const int SubFieldNumber = 1;
    private static readonly pb::FieldCodec<global::InfX.ConfigSubCategories> _repeated_sub_codec
        = pb::FieldCodec.ForMessage(10, global::InfX.ConfigSubCategories.Parser);
    private readonly pbc::RepeatedField<global::InfX.ConfigSubCategories> sub_ = new pbc::RepeatedField<global::InfX.ConfigSubCategories>();
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public pbc::RepeatedField<global::InfX.ConfigSubCategories> Sub {
      get { return sub_; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override bool Equals(object other) {
      return Equals(other as ConfigCategories);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public bool Equals(ConfigCategories other) {
      if (ReferenceEquals(other, null)) {
        return false;
      }
      if (ReferenceEquals(other, this)) {
        return true;
      }
      if(!sub_.Equals(other.sub_)) return false;
      return true;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override int GetHashCode() {
      int hash = 1;
      hash ^= sub_.GetHashCode();
      return hash;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override string ToString() {
      return pb::JsonFormatter.ToDiagnosticString(this);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void WriteTo(pb::CodedOutputStream output) {
      sub_.WriteTo(output, _repeated_sub_codec);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int CalculateSize() {
      int size = 0;
      size += sub_.CalculateSize(_repeated_sub_codec);
      return size;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(ConfigCategories other) {
      if (other == null) {
        return;
      }
      sub_.Add(other.sub_);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(pb::CodedInputStream input) {
      uint tag;
      while ((tag = input.ReadTag()) != 0) {
        switch(tag) {
          default:
            input.SkipLastField();
            break;
          case 10: {
            sub_.AddEntriesFrom(input, _repeated_sub_codec);
            break;
          }
        }
      }
    }

  }

  public sealed partial class Config : pb::IMessage<Config> {
    private static readonly pb::MessageParser<Config> _parser = new pb::MessageParser<Config>(() => new Config());
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pb::MessageParser<Config> Parser { get { return _parser; } }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pbr::MessageDescriptor Descriptor {
      get { return global::InfX.InfReflection.Descriptor.MessageTypes[2]; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    pbr::MessageDescriptor pb::IMessage.Descriptor {
      get { return Descriptor; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public Config() {
      OnConstruction();
    }

    partial void OnConstruction();

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public Config(Config other) : this() {
      Categories = other.categories_ != null ? other.Categories.Clone() : null;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public Config Clone() {
      return new Config(this);
    }

    /// <summary>Field number for the "categories" field.</summary>
    public const int CategoriesFieldNumber = 1;
    private global::InfX.ConfigCategories categories_;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public global::InfX.ConfigCategories Categories {
      get { return categories_; }
      set {
        categories_ = value;
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override bool Equals(object other) {
      return Equals(other as Config);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public bool Equals(Config other) {
      if (ReferenceEquals(other, null)) {
        return false;
      }
      if (ReferenceEquals(other, this)) {
        return true;
      }
      if (!object.Equals(Categories, other.Categories)) return false;
      return true;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override int GetHashCode() {
      int hash = 1;
      if (categories_ != null) hash ^= Categories.GetHashCode();
      return hash;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override string ToString() {
      return pb::JsonFormatter.ToDiagnosticString(this);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void WriteTo(pb::CodedOutputStream output) {
      if (categories_ != null) {
        output.WriteRawTag(10);
        output.WriteMessage(Categories);
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int CalculateSize() {
      int size = 0;
      if (categories_ != null) {
        size += 1 + pb::CodedOutputStream.ComputeMessageSize(Categories);
      }
      return size;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(Config other) {
      if (other == null) {
        return;
      }
      if (other.categories_ != null) {
        if (categories_ == null) {
          categories_ = new global::InfX.ConfigCategories();
        }
        Categories.MergeFrom(other.Categories);
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(pb::CodedInputStream input) {
      uint tag;
      while ((tag = input.ReadTag()) != 0) {
        switch(tag) {
          default:
            input.SkipLastField();
            break;
          case 10: {
            if (categories_ == null) {
              categories_ = new global::InfX.ConfigCategories();
            }
            input.ReadMessage(categories_);
            break;
          }
        }
      }
    }

  }

  public sealed partial class CategoryId : pb::IMessage<CategoryId> {
    private static readonly pb::MessageParser<CategoryId> _parser = new pb::MessageParser<CategoryId>(() => new CategoryId());
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pb::MessageParser<CategoryId> Parser { get { return _parser; } }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pbr::MessageDescriptor Descriptor {
      get { return global::InfX.InfReflection.Descriptor.MessageTypes[3]; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    pbr::MessageDescriptor pb::IMessage.Descriptor {
      get { return Descriptor; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public CategoryId() {
      OnConstruction();
    }

    partial void OnConstruction();

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public CategoryId(CategoryId other) : this() {
      main_ = other.main_;
      sub_ = other.sub_;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public CategoryId Clone() {
      return new CategoryId(this);
    }

    /// <summary>Field number for the "main" field.</summary>
    public const int MainFieldNumber = 1;
    private int main_;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int Main {
      get { return main_; }
      set {
        main_ = value;
      }
    }

    /// <summary>Field number for the "sub" field.</summary>
    public const int SubFieldNumber = 2;
    private int sub_;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int Sub {
      get { return sub_; }
      set {
        sub_ = value;
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override bool Equals(object other) {
      return Equals(other as CategoryId);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public bool Equals(CategoryId other) {
      if (ReferenceEquals(other, null)) {
        return false;
      }
      if (ReferenceEquals(other, this)) {
        return true;
      }
      if (Main != other.Main) return false;
      if (Sub != other.Sub) return false;
      return true;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override int GetHashCode() {
      int hash = 1;
      if (Main != 0) hash ^= Main.GetHashCode();
      if (Sub != 0) hash ^= Sub.GetHashCode();
      return hash;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override string ToString() {
      return pb::JsonFormatter.ToDiagnosticString(this);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void WriteTo(pb::CodedOutputStream output) {
      if (Main != 0) {
        output.WriteRawTag(8);
        output.WriteInt32(Main);
      }
      if (Sub != 0) {
        output.WriteRawTag(16);
        output.WriteInt32(Sub);
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int CalculateSize() {
      int size = 0;
      if (Main != 0) {
        size += 1 + pb::CodedOutputStream.ComputeInt32Size(Main);
      }
      if (Sub != 0) {
        size += 1 + pb::CodedOutputStream.ComputeInt32Size(Sub);
      }
      return size;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(CategoryId other) {
      if (other == null) {
        return;
      }
      if (other.Main != 0) {
        Main = other.Main;
      }
      if (other.Sub != 0) {
        Sub = other.Sub;
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(pb::CodedInputStream input) {
      uint tag;
      while ((tag = input.ReadTag()) != 0) {
        switch(tag) {
          default:
            input.SkipLastField();
            break;
          case 8: {
            Main = input.ReadInt32();
            break;
          }
          case 16: {
            Sub = input.ReadInt32();
            break;
          }
        }
      }
    }

  }

  public sealed partial class CategoryIdSet : pb::IMessage<CategoryIdSet> {
    private static readonly pb::MessageParser<CategoryIdSet> _parser = new pb::MessageParser<CategoryIdSet>(() => new CategoryIdSet());
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pb::MessageParser<CategoryIdSet> Parser { get { return _parser; } }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pbr::MessageDescriptor Descriptor {
      get { return global::InfX.InfReflection.Descriptor.MessageTypes[4]; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    pbr::MessageDescriptor pb::IMessage.Descriptor {
      get { return Descriptor; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public CategoryIdSet() {
      OnConstruction();
    }

    partial void OnConstruction();

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public CategoryIdSet(CategoryIdSet other) : this() {
      ids_ = other.ids_.Clone();
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public CategoryIdSet Clone() {
      return new CategoryIdSet(this);
    }

    /// <summary>Field number for the "ids" field.</summary>
    public const int IdsFieldNumber = 1;
    private static readonly pb::FieldCodec<global::InfX.CategoryId> _repeated_ids_codec
        = pb::FieldCodec.ForMessage(10, global::InfX.CategoryId.Parser);
    private readonly pbc::RepeatedField<global::InfX.CategoryId> ids_ = new pbc::RepeatedField<global::InfX.CategoryId>();
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public pbc::RepeatedField<global::InfX.CategoryId> Ids {
      get { return ids_; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override bool Equals(object other) {
      return Equals(other as CategoryIdSet);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public bool Equals(CategoryIdSet other) {
      if (ReferenceEquals(other, null)) {
        return false;
      }
      if (ReferenceEquals(other, this)) {
        return true;
      }
      if(!ids_.Equals(other.ids_)) return false;
      return true;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override int GetHashCode() {
      int hash = 1;
      hash ^= ids_.GetHashCode();
      return hash;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override string ToString() {
      return pb::JsonFormatter.ToDiagnosticString(this);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void WriteTo(pb::CodedOutputStream output) {
      ids_.WriteTo(output, _repeated_ids_codec);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int CalculateSize() {
      int size = 0;
      size += ids_.CalculateSize(_repeated_ids_codec);
      return size;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(CategoryIdSet other) {
      if (other == null) {
        return;
      }
      ids_.Add(other.ids_);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(pb::CodedInputStream input) {
      uint tag;
      while ((tag = input.ReadTag()) != 0) {
        switch(tag) {
          default:
            input.SkipLastField();
            break;
          case 10: {
            ids_.AddEntriesFrom(input, _repeated_ids_codec);
            break;
          }
        }
      }
    }

  }

  #endregion

}

#endregion Designer generated code
