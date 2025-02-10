package main

import (
	"log"

	"github.com/IBM/sarama"
)

func main() {
	brokerList := []string{"localhost:9092"}

	consumer, err := newConsumer(brokerList)
	if err != nil {
		log.Fatalf("Failed to start Sarama consumer: %v", err)
	}

	consumeMessages(consumer)
}

// func newProducer(brokers []string) (sarama.SyncProducer, error) {
// 	config := sarama.NewConfig()
// 	config.Producer.RequiredAcks = sarama.WaitForAll
// 	config.Producer.Retry.Max = 5
// 	config.Producer.Return.Successes = true

// 	producer, err := sarama.NewSyncProducer(brokers, config)
// 	if err != nil {
// 		return nil, err
// 	}
// 	return producer, nil
// }

func newConsumer(brokers []string) (sarama.Consumer, error) {
	config := sarama.NewConfig()
	consumer, err := sarama.NewConsumer(brokers, config)
	if err != nil {
		return nil, err
	}
	return consumer, nil
}

// func produceMessages(producer sarama.SyncProducer, topic string) {
	// for {
	// 	msg := &sarama.ProducerMessage{
	// 		Topic: topic,
	// 		Value: sarama.StringEncoder(fmt.Sprintf("Message at %s", time.Now().String())),
	// 	}
	// 	_, _, err := producer.SendMessage(msg)
	// 	if err != nil {
	// 		log.Printf("Failed to send message: %v", err)
	// 	}
	// 	time.Sleep(2 * time.Second)
	// }
// }

func consumeMessages(consumer sarama.Consumer) {
	partitionConsumer, err := consumer.ConsumePartition("my-vehicles", 0, sarama.OffsetNewest)
	if err != nil {
		log.Fatalf("Failed to start consumer for partition: %v", err)
	}
	defer partitionConsumer.Close()

	for msg := range partitionConsumer.Messages() {
		log.Printf("Consumed message: %s", string(msg.Value))
	}
}
