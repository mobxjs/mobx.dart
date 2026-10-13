import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../site/stores.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key, required this.store});
  final CartStore store;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        LucideIcons.sparkles,
        size: 21,
        color: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(width: 8),
      const Text(
        'little things',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      const Spacer(),
      const Text('Bag', style: TextStyle(fontSize: 12)),
      const SizedBox(width: 8),
      Observer(
        builder: (_) => Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${store.quantity.value}',
            semanticsLabel: 'Bag count ${store.quantity.value}',
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
    ],
  );
}

class CartProduct extends StatelessWidget {
  const CartProduct({super.key, required this.store});
  final CartStore store;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Divider(height: 1),
      const SizedBox(height: 18),
      Row(
        children: [
          Container(
            width: 75,
            height: 90,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: .35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              LucideIcons.notebook,
              size: 45,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The everyday notebook',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Text(r'$24.00'),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      Row(
        children: [
          const Text('Make it yours', style: TextStyle(fontSize: 12)),
          const Spacer(),
          Observer(
            builder: (_) => Row(
              children: [
                IconButton(
                  tooltip: 'Remove one notebook',
                  onPressed: store.quantity.value == 0
                      ? null
                      : () => store.change(-1),
                  icon: const Icon(LucideIcons.minus, size: 18),
                ),
                SizedBox(
                  width: 26,
                  child: Text(
                    '${store.quantity.value}',
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  tooltip: 'Add one notebook',
                  onPressed: store.quantity.value == 99
                      ? null
                      : () => store.change(1),
                  icon: const Icon(LucideIcons.plus, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

class CartSummary extends StatelessWidget {
  const CartSummary({super.key, required this.store});
  final CartStore store;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      Observer(
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (store.total.value / 72).clamp(0, 1),
              minHeight: 5,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 9),
            Text(
              store.shippingRemaining.value == 0
                  ? 'Lovely! Your shipping is on us.'
                  : "You’re \$${store.shippingRemaining.value} away from free shipping.",
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
      const SizedBox(height: 13),
      const Divider(),
      Row(
        children: [
          const Text('Subtotal', style: TextStyle(fontSize: 12)),
          const Spacer(),
          Observer(
            builder: (_) => Text(
              '\$${store.total.value}.00',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 7,
        children: [
          for (final label in ['Product page', 'Cart badge', 'Checkout'])
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(label, style: const TextStyle(fontSize: 9)),
            ),
        ],
      ),
    ],
  );
}

Widget buildExample(DemoStores stores) => Column(
  children: [
    SizedBox(height: 64, child: CartHeader(store: stores.cart)),
    CartProduct(store: stores.cart),
    CartSummary(store: stores.cart),
  ],
);
