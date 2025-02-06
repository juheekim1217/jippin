import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class AdvancedBehaviorAutocomplete<T extends Object> extends StatelessWidget {
  const AdvancedBehaviorAutocomplete({
    super.key,
    required this.optionsBuilder,
    this.validator,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.onSelected,
    this.optionsMaxHeight = 200.0,
    this.optionsViewBuilder,
    this.initialValue,
    this.moveFocusNext = true,
  });

  final String? Function(String?)? validator;

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteFieldViewBuilder fieldViewBuilder;

  final AutocompleteOnSelected<T>? onSelected;

  final AutocompleteOptionsBuilder<T> optionsBuilder;

  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;

  final double optionsMaxHeight;

  final TextEditingValue? initialValue;

  final bool? moveFocusNext;

  static Widget _defaultFieldViewBuilder(BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
    return _AutocompleteField(
      focusNode: focusNode,
      textEditingController: textEditingController,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedBehaviorRawAutocomplete<T>(
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: fieldViewBuilder,
      initialValue: initialValue,
      optionsBuilder: optionsBuilder,
      optionsViewBuilder: optionsViewBuilder ??
          (BuildContext context, AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
            return _AutocompleteOptions<T>(
              displayStringForOption: displayStringForOption,
              onSelected: onSelected,
              options: options,
              maxOptionsHeight: optionsMaxHeight,
            );
          },
      onSelected: onSelected,
      moveFocusNext: moveFocusNext,
    );
  }
}

class _AutocompleteField extends StatelessWidget {
  const _AutocompleteField({
    required this.focusNode,
    required this.textEditingController,
    required this.onFieldSubmitted,
  });

  final FocusNode focusNode;

  final VoidCallback onFieldSubmitted;

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: textEditingController,
      focusNode: focusNode,
      onFieldSubmitted: (String value) {
        onFieldSubmitted();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required entry or selection';
        }
        return null;
      },
    );
  }
}

class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  const _AutocompleteOptions({
    super.key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
  });

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;
  final double maxOptionsHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxOptionsHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return InkWell(
                //onTap: () {
                onTapDown: (TapDownDetails details) {
                  debugPrint('onTapDown');
                  onSelected(option);
                },
                child: Builder(builder: (BuildContext context) {
                  final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(displayStringForOption(option)),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AdvancedBehaviorRawAutocomplete<T extends Object> extends StatefulWidget {
  const AdvancedBehaviorRawAutocomplete({
    super.key,
    required this.optionsViewBuilder,
    required this.optionsBuilder,
    this.displayStringForOption = defaultStringForOption,
    this.fieldViewBuilder,
    this.focusNode,
    this.onSelected,
    this.textEditingController,
    this.initialValue,
    this.moveFocusNext,
  })  : assert(
          fieldViewBuilder != null || (key != null && focusNode != null && textEditingController != null),
          'Pass in a fieldViewBuilder, or otherwise create a separate field and pass in the FocusNode, TextEditingController, and a key. Use the key with RawAutocomplete.onFieldSubmitted.',
        ),
        assert((focusNode == null) == (textEditingController == null)),
        assert(
          !(textEditingController != null && initialValue != null),
          'textEditingController and initialValue cannot be simultaneously defined.',
        );

  final AutocompleteFieldViewBuilder? fieldViewBuilder;

  final FocusNode? focusNode;

  final AutocompleteOptionsViewBuilder<T> optionsViewBuilder;

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T>? onSelected;

  final AutocompleteOptionsBuilder<T> optionsBuilder;

  final TextEditingController? textEditingController;

  final TextEditingValue? initialValue;

  final bool? moveFocusNext;

  static void onFieldSubmitted<T extends Object>(GlobalKey key) {
    final _AdvancedBehaviorRawAutocompleteState<T> rawAutocomplete = key.currentState! as _AdvancedBehaviorRawAutocompleteState<T>;
    rawAutocomplete._onFieldSubmitted();
  }

  static String defaultStringForOption(dynamic option) {
    return option.toString();
  }

  @override
  State<AdvancedBehaviorRawAutocomplete<T>> createState() => _AdvancedBehaviorRawAutocompleteState<T>();
}

class _AdvancedBehaviorRawAutocompleteState<T extends Object> extends State<AdvancedBehaviorRawAutocomplete<T>> {
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _optionsLayerLink = LayerLink();
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  late final Map<Type, Action<Intent>> _actionMap;
  late final _AutocompleteCallbackAction<AutocompletePreviousOptionIntent> _previousOptionAction;
  late final _AutocompleteCallbackAction<AutocompleteNextOptionIntent> _nextOptionAction;
  late final _AutocompleteCallbackAction<AutocompleteTabIntent> _tabAction;
  Iterable<T> _options = Iterable<T>.empty();
  T? _selection;
  final ValueNotifier<int> _highlightedOptionIndex = ValueNotifier<int>(0);

  static const Map<ShortcutActivator, Intent> _shortcuts = <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowUp): AutocompletePreviousOptionIntent(),
    SingleActivator(LogicalKeyboardKey.arrowDown): AutocompleteNextOptionIntent(),
    SingleActivator(LogicalKeyboardKey.tab): AutocompleteTabIntent(),
  };

  OverlayEntry? _floatingOptions;

  bool get _shouldShowOptions {
    return _focusNode.hasFocus && _selection == null && _options.isNotEmpty;
  }

  Future<void> _onChangedField() async {
    final Iterable<T> options = await widget.optionsBuilder(
      _textEditingController.value,
    );
    _options = options;
    _updateHighlight(_highlightedOptionIndex.value);
    if (_selection != null && _textEditingController.text != widget.displayStringForOption(_selection!)) {
      _selection = null;
    }
    _updateOverlay();
  }

  void _onChangedFocus() {
    _updateOverlay();
  }

  void _onFieldSubmitted() {
    if (_options.isEmpty && _textEditingController.value.text.isEmpty) {
      return;
    }
    if (_options.isEmpty && _textEditingController.value.text.isNotEmpty) {
      _selection = _textEditingController.value.text as T;
      widget.onSelected?.call(_selection!);
      if (widget.moveFocusNext!) {
        _focusNode.nextFocus();
        //_focusNode.nextFocus(); // move to second next focus
        //FocusScope.of(context).requestFocus(nextFieldFocusNode); // manually setting the focus to the next field:
      } else {
        FocusScope.of(context).unfocus(); // This will close the keyboard but not move focus.
      }
      return;
    }

    _select(_options.elementAt(_highlightedOptionIndex.value), selectedWithMouse: false);
    if (widget.moveFocusNext!) {
      _focusNode.nextFocus();
      //_focusNode.nextFocus(); // move to second next focus
      //FocusScope.of(context).requestFocus(nextFieldFocusNode); // manually setting the focus to the next field:
    } else {
      FocusScope.of(context).unfocus(); // This will close the keyboard but not move focus.
    }
    debugPrint("moveFocusNext ${widget.moveFocusNext}");
  }

  void _select(T nextSelection, {bool selectedWithMouse = true}) {
    if (nextSelection == _selection) {
      return;
    }
    _selection = nextSelection;
    final String selectionString = widget.displayStringForOption(nextSelection);
    _textEditingController.value = TextEditingValue(
      selection: TextSelection.collapsed(offset: selectionString.length),
      text: selectionString,
    );
    widget.onSelected?.call(_selection!);
    if (selectedWithMouse) {
      FocusScope.of(context).requestFocus(_focusNode); // Keep focus on the input field
    }
  }

  void _updateHighlight(int newIndex) {
    _highlightedOptionIndex.value = _options.isEmpty ? 0 : newIndex % _options.length;
  }

  void _highlightPreviousOption(AutocompletePreviousOptionIntent intent) {
    _updateHighlight(_highlightedOptionIndex.value - 1);
  }

  void _highlightNextOption(AutocompleteNextOptionIntent intent) {
    _updateHighlight(_highlightedOptionIndex.value + 1);
  }

  void _handleTabPressed(AutocompleteTabIntent intent) {
    _selection = _textEditingController.value.text as T;
    widget.onSelected?.call(_selection!);
    _focusNode.nextFocus();
  }

  void _setActionsEnabled(bool enabled) {
    _previousOptionAction.enabled = enabled;
    _nextOptionAction.enabled = enabled;
    _tabAction.enabled = enabled;
  }

  void _updateOverlay() {
    _setActionsEnabled(_shouldShowOptions);
    if (_shouldShowOptions) {
      _floatingOptions?.remove();
      _floatingOptions = OverlayEntry(
        builder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _optionsLayerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            child: AutocompleteHighlightedOption(
                highlightIndexNotifier: _highlightedOptionIndex,
                child: Builder(builder: (BuildContext context) {
                  return widget.optionsViewBuilder(context, _select, _options);
                })),
          );
        },
      );
      Overlay.of(context, rootOverlay: true).insert(_floatingOptions!);
    } else if (_floatingOptions != null) {
      _floatingOptions?.remove();
      _floatingOptions = null;
    }
  }

  void _updateTextEditingController(TextEditingController? old, TextEditingController? current) {
    if ((old == null && current == null) || old == current) {
      return;
    }
    if (old == null) {
      _textEditingController.removeListener(_onChangedField);
      _textEditingController.dispose();
      _textEditingController = current!;
    } else if (current == null) {
      _textEditingController.removeListener(_onChangedField);
      _textEditingController = TextEditingController();
    } else {
      _textEditingController.removeListener(_onChangedField);
      _textEditingController = current;
    }
    _textEditingController.addListener(_onChangedField);
  }

  void _updateFocusNode(FocusNode? old, FocusNode? current) {
    if ((old == null && current == null) || old == current) {
      return;
    }
    if (old == null) {
      _focusNode.removeListener(_onChangedFocus);
      _focusNode.dispose();
      _focusNode = current!;
    } else if (current == null) {
      _focusNode.removeListener(_onChangedFocus);
      _focusNode = FocusNode();
    } else {
      _focusNode.removeListener(_onChangedFocus);
      _focusNode = current;
    }
    _focusNode.addListener(_onChangedFocus);
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.textEditingController ?? TextEditingController.fromValue(widget.initialValue);
    _textEditingController.addListener(_onChangedField);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onChangedFocus);
    _previousOptionAction = _AutocompleteCallbackAction<AutocompletePreviousOptionIntent>(onInvoke: _highlightPreviousOption);
    _nextOptionAction = _AutocompleteCallbackAction<AutocompleteNextOptionIntent>(onInvoke: _highlightNextOption);
    _tabAction = _AutocompleteCallbackAction<AutocompleteTabIntent>(onInvoke: _handleTabPressed);
    _actionMap = <Type, Action<Intent>>{
      AutocompletePreviousOptionIntent: _previousOptionAction,
      AutocompleteNextOptionIntent: _nextOptionAction,
      AutocompleteTabIntent: _tabAction,
    };
    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      _updateOverlay();
    });
  }

  @override
  void didUpdateWidget(AdvancedBehaviorRawAutocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTextEditingController(
      oldWidget.textEditingController,
      widget.textEditingController,
    );
    _updateFocusNode(oldWidget.focusNode, widget.focusNode);
    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      _updateOverlay();
    });
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onChangedField);
    if (widget.textEditingController == null) {
      _textEditingController.dispose();
    }
    _focusNode.removeListener(_onChangedFocus);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _floatingOptions?.remove();
    _floatingOptions = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _focusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if (_options.isNotEmpty) {
            _select(_options.elementAt(_highlightedOptionIndex.value), selectedWithMouse: false);
          }
          return KeyEventResult.handled; // Prevents default behavior if needed
        }
      }
      return KeyEventResult.ignored;
    };
    return Container(
      key: _fieldKey,
      child: Shortcuts(
        shortcuts: _shortcuts,
        child: Actions(
          actions: _actionMap,
          child: CompositedTransformTarget(
            link: _optionsLayerLink,
            child: widget.fieldViewBuilder == null
                ? const SizedBox.shrink()
                : widget.fieldViewBuilder!(
                    context,
                    _textEditingController,
                    _focusNode,
                    _onFieldSubmitted,
                  ),
          ),
        ),
      ),
    );
  }
}

class _AutocompleteCallbackAction<T extends Intent> extends CallbackAction<T> {
  _AutocompleteCallbackAction({
    required super.onInvoke,
    this.enabled = true,
  });

  bool enabled;

  @override
  bool isEnabled(covariant T intent) => enabled;

  @override
  bool consumesKey(covariant T intent) => enabled;
}

class AutocompletePreviousOptionIntent extends Intent {
  const AutocompletePreviousOptionIntent();
}

class AutocompleteNextOptionIntent extends Intent {
  const AutocompleteNextOptionIntent();
}

class AutocompleteTabIntent extends Intent {
  const AutocompleteTabIntent();
}
