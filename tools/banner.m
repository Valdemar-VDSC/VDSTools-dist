#import <AppKit/AppKit.h>

static void rrect(NSRect r, CGFloat rad, NSColor *fill, NSColor *stroke, CGFloat lw) {
  NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:r xRadius:rad yRadius:rad];
  if (fill) { [fill set]; [p fill]; }
  if (stroke) { [stroke set]; p.lineWidth = lw; [p stroke]; }
}
static void draw(NSString *s, NSPoint at, NSFont *f, NSColor *c, CGFloat tracking) {
  NSMutableDictionary *a = [@{NSFontAttributeName:f, NSForegroundColorAttributeName:c} mutableCopy];
  if (tracking != 0) a[NSKernAttributeName] = @(tracking);
  [s drawAtPoint:at withAttributes:a];
}
static void render(NSString *out, CGFloat H, BOOL en) {
  const CGFloat W = 1280, S = 1.5;   // 1920 px de large : assez pour un écran Retina, deux fois moins lourd qu'en 2x
  const CGFloat dy = (H - 440) / 2;
  NSColor *ink   = [NSColor colorWithSRGBRed:0.925 green:0.941 blue:0.957 alpha:1];
  NSColor *muted = [NSColor colorWithSRGBRed:0.53 green:0.58 blue:0.63 alpha:1];
  NSColor *acc   = [NSColor colorWithSRGBRed:0.298 green:0.745 blue:0.792 alpha:1];
  NSColor *bg1   = [NSColor colorWithSRGBRed:0.047 green:0.059 blue:0.075 alpha:1];
  NSColor *bg2   = [NSColor colorWithSRGBRed:0.074 green:0.114 blue:0.133 alpha:1];
  NSColor *card  = [NSColor colorWithSRGBRed:0.086 green:0.11  blue:0.129 alpha:1];
  NSColor *rule  = [NSColor colorWithSRGBRed:0.16  green:0.20  blue:0.23  alpha:1];

  NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
      pixelsWide:W*S pixelsHigh:H*S bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO
      colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
  rep.size = NSMakeSize(W, H);
  NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
  [NSGraphicsContext saveGraphicsState];
  [NSGraphicsContext setCurrentContext:ctx];

  // Fond PLAT, et non un dégradé : NSGradient tramait, ce qui faisait un PNG de
  // 800 Ko pour une image qui n'a qu'une poignée de couleurs. Un aplat, et une
  // nappe d'accent posée en coin, donnent la même impression pour 30 Ko.
  [bg1 set]; NSRectFill(NSMakeRect(0,0,W,H));
  // Une nappe d'accent derrière la figure, en douze couches à peine visibles :
  // le bord franc d'une seule forme se voyait comme un défaut.
  for (int i = 0; i < 12; i++) {
    CGFloat k = (CGFloat)i / 12.0, r = 240 + k * 320;
    [[bg2 colorWithAlphaComponent:.075] set];
    [[NSBezierPath bezierPathWithOvalInRect:
        NSMakeRect(W*0.76 - r, H*0.52 - r*0.72, r*2, r*1.44)] fill];
  }

  // ── à droite : une figure abstraite de fenêtre, pas une fausse capture ──
  CGFloat wx = 720, wy = 74+dy, ww = 490, wh = 292;
  rrect(NSMakeRect(wx, wy, ww, wh), 12, card, rule, 1);
  rrect(NSMakeRect(wx, wy+wh-38, ww, 38), 12, [NSColor colorWithSRGBRed:0.11 green:0.14 blue:0.16 alpha:1], nil, 0);
  NSRectFill(NSMakeRect(wx, wy+wh-39, ww, 1));
  [rule set]; NSRectFill(NSMakeRect(wx, wy+wh-39, ww, 1));
  for (int i = 0; i < 3; i++) {
    NSColor *d = i==0 ? [NSColor colorWithSRGBRed:.98 green:.37 blue:.35 alpha:1]
               : i==1 ? [NSColor colorWithSRGBRed:.99 green:.74 blue:.24 alpha:1]
                      : [NSColor colorWithSRGBRed:.35 green:.79 blue:.35 alpha:1];
    rrect(NSMakeRect(wx+16+i*18, wy+wh-24, 11, 11), 5.5, d, nil, 0);
  }
  // barre latérale
  rrect(NSMakeRect(wx+1, wy+1, 150, wh-40), 0, [NSColor colorWithSRGBRed:0.067 green:0.086 blue:0.102 alpha:1], nil, 0);
  for (int i = 0; i < 6; i++) {
    CGFloat y = wy+wh-78-i*30;
    if (i == 1) rrect(NSMakeRect(wx+10, y-6, 132, 24), 6, [acc colorWithAlphaComponent:.22], nil, 0);
    rrect(NSMakeRect(wx+20, y, 12, 12), 3, i==1 ? acc : muted, nil, 0);
    rrect(NSMakeRect(wx+40, y+3, 70+((i*17)%40), 6), 3, [muted colorWithAlphaComponent:i==1?.9:.5], nil, 0);
  }
  // contenu : des lignes de tableau
  for (int i = 0; i < 6; i++) {
    CGFloat y = wy+wh-78-i*30;
    if (i % 2) rrect(NSMakeRect(wx+152, y-8, ww-154, 28), 0, [NSColor colorWithSRGBRed:0.1 green:0.126 blue:0.145 alpha:1], nil, 0);
    rrect(NSMakeRect(wx+172, y+3, 120, 6), 3, [muted colorWithAlphaComponent:.55], nil, 0);
    rrect(NSMakeRect(wx+320, y+3, 60, 6), 3, [muted colorWithAlphaComponent:.35], nil, 0);
    rrect(NSMakeRect(wx+400, y, 44, 12), 6, [acc colorWithAlphaComponent:.30], nil, 0);
  }

  // ── à gauche : le texte ──
  draw(@"VDSTools", NSMakePoint(80, 250+dy),
       [NSFont systemFontOfSize:72 weight:NSFontWeightHeavy], ink, -1.6);
  rrect(NSMakeRect(82, 236+dy, 86, 5), 2.5, acc, nil, 0);
  draw(en ? @"Native macOS for Xojo, in pure Xojo" : @"macOS natif pour Xojo, en Xojo pur", NSMakePoint(80, 192+dy),
       [NSFont systemFontOfSize:23 weight:NSFontWeightMedium], ink, 0);
  draw(en ? @"No plugin, no external framework, no compiled Objective-C —" : @"Aucun plugin, aucun framework externe, aucun Objective-C compilé —", NSMakePoint(80, 160+dy),
       [NSFont systemFontOfSize:15 weight:NSFontWeightRegular], muted, 0);
  draw(en ? @"only Declares." : @"uniquement des Declare.", NSMakePoint(80, 138+dy),
       [NSFont systemFontOfSize:15 weight:NSFontWeightRegular], muted, 0);

  NSArray *chips = en ? @[@"100 classes", @"27 IDE controls", @"macOS 15+"] : @[@"100 classes", @"27 contrôles dans l'IDE", @"macOS 15+"];
  CGFloat cx = 80;
  for (NSString *c in chips) {
    NSFont *f = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
    CGFloat tw = [c sizeWithAttributes:@{NSFontAttributeName:f}].width;
    rrect(NSMakeRect(cx, 74+dy, tw+26, 30), 15, [acc colorWithAlphaComponent:.14], [acc colorWithAlphaComponent:.45], 1);
    draw(c, NSMakePoint(cx+13, 82+dy), f, acc, 0);
    cx += tw + 26 + 10;
  }

  [NSGraphicsContext restoreGraphicsState];
  [[rep representationUsingType:NSBitmapImageFileTypePNG properties:@{}] writeToFile:out atomically:YES];
  printf("%s : %.0fx%.0f à %.0fx\n", out.lastPathComponent.UTF8String, W, H, S);
}
int main(int argc, char **argv) { @autoreleasepool {
  [NSApplication sharedApplication];
  NSString *d = [NSString stringWithUTF8String:argv[1]];
  render([d stringByAppendingPathComponent:@"banner-fr.png"], 440, NO);
  render([d stringByAppendingPathComponent:@"banner-en.png"], 440, YES);
  render([d stringByAppendingPathComponent:@"social.png"], 640, NO);
}}
