HELP="Try running: KEY=yourkey HOST=hostname.domain RSYNC_TARGET=user@hostname.domain $0"
: "${RSYNC_TARGET:?Variable not set or empty. $HELP}"
: "${HOST:?Variable not set or empty. $HELP}"
: "${KEY:?Variable not set or empty. $HELP}"

pushd "$(dirname "$0")" > /dev/null
sed -i "s/<key>/$KEY/g" fvapp-*.service
sed -i "s/<host>/$HOST/g" fvapp-*.service
ssh $RSYNC_TARGET "mkdir -p /apps/rustdesk"
rsync -av ./apimain $RSYNC_TARGET:/apps/rustdesk/
rsync -av ./docs $RSYNC_TARGET:/apps/rustdesk/
rsync -av ./resources $RSYNC_TARGET:/apps/rustdesk/
pushd ../../rustdesk-api-web/ > /dev/null
npm i
npm run build
rsync -av dist/ $RSYNC_TARGET:/apps/rustdesk/resources/admin/
popd > /dev/null
popd > /dev/null