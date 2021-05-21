import 'package:bannertest/ui_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

extension StringParsing on String {
  List<AdSize> get toSizes {
    switch (this) {
      case UITexts.admobBannerSquare:
        return [AdSize.mediumRectangle];
      case UITexts.admobBannerApp:
        return [AdSize.largeBanner, AdSize.banner];
      default:
        return [AdSize.largeBanner, AdSize.banner];
    }
  }
}

class AdBanner extends StatefulWidget {
  const AdBanner({
    required this.adUnit,
  });
  final String adUnit;
  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  bool _hasFailed = false;
  AdManagerBannerAd? banner;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _loadBanner();
    });
  }

  void _loadBanner() => AdManagerBannerAd(
        adUnitId: widget.adUnit,
        sizes: widget.adUnit.toSizes,
        request: AdManagerAdRequest(
          contentUrl: UITexts.urlSM,
        ),
        listener: AdManagerBannerAdListener(onAdLoaded: (Ad ad) {
          setState(() {
            banner = ad as AdManagerBannerAd;
          });
          print('${widget.adUnit} loaded.');
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print(' Failed to load with code: ${error.toString()}');
          setState(() {
            _hasFailed = true;
          });
        }),
      ).load();

  @override
  Widget build(BuildContext context) {
    if (_hasFailed) {
      return Container(
        child: Text('Failed'),
      );
    }
    if (banner == null) {
      return Container();
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: banner!.sizes.first.height.toDouble() + 10,
      ),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: banner!.sizes.first.width.toDouble(),
                height: banner!.sizes.first.height.toDouble(),
                alignment: Alignment.center,
                child: AdWidget(
                  ad: banner!,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
