import { CloudEvent, cloudEvent } from '@google-cloud/functions-framework'

type PubSubEventData = {
  message: {
    data: string
  }
}

cloudEvent('helloPubSub', (cloudEvent: CloudEvent<PubSubEventData>) => {
  const base64name = cloudEvent.data?.message.data

  const name = base64name
    ? Buffer.from(base64name, 'base64').toString()
    : 'World'

  console.log(`Hello, ${name}!`)
})
